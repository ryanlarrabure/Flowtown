import urllib2
import urllib
import cookielib
import subprocess

from lxml import etree
from lettuce import after, step, before

from config import Config

class OpenVBX_Connection:
    
    def __init__ (self):
        self.con = None
        self.current_page = None
        self.outgoing_data = dict() # Data to be sent in the next request



def load_mysql_database(filename):
    
    # The filename should point to a file containing SQL commands.  We're just
    # piping this into mysql.

    args = []
    f = open(filename, 'r')

    if not Config.MySQL.password:
        args = [Config.MySQL.mysql, '-u', Config.MySQL.user,
                Config.MySQL.database]
    else:
        args = [Config.MySQL.mysql, '-u', Config.MySQL.user, '-p%s' %
                Config.MySQL.password, Config.MySQL.database]
    proc = subprocess.Popen(args, stdin=f)

    f.close()


@before.all
def before_all():
    global cj # CookieJar Object
    global opener # urllib2 opener object

    # Dump the database

    args = []
    temp_file = open(Config.MySQL.backup_file, 'w')

    if not Config.MySQL.password:
        args = [Config.MySQL.dump_path, '-c', '-u', Config.MySQL.user,
                Config.MySQL.database, 'flows']
    else:
        args = [Config.MySQL.dump_path, '-c', '-u', Config.MySQL.user, '-p%s' %
                Config.MySQL.password, Config.MySQL.database, 'flows']
    proc = subprocess.Popen(args, stdout=temp_file)

    temp_file.flush()
    temp_file.close()

    # Setup the cookie handler

    cj = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))

@after.all
def after_all(total):

    # We load the backed up database, and destroy the cookiejar and urllib2
    # opener object

    global cj
    global opener

    load_mysql_database(Config.MySQL.backup_file)

    cj = None
    opener = None

@before.each_scenario
def before_each_scenario(scenario):

    # Setup our OpenVBX data holder

    global ovbx
    global cj
    global opener
   
    ovbx = OpenVBX_Connection() 
    
    # Setup the cookie handler

    cj = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))


@after.each_scenario
def after_each_scenario(scenario):

    # Destroy our OpenVBX data holder

    global ovbx

    ovbx = None


def assert_open_and_read(url, expectData=True):

    # This opens, reads, sets the current page object, and asserts that the
    # page is not empty.

    if ovbx.con:
        ovbx.con.close()
        ovbx.con = None
    try:
        if not ovbx.outgoing_data:
            ovbx.con = opener.open(url)
        else:
            ovbx.con = opener.open(url, urllib.urlencode(ovbx.outgoing_data))
            ovbx.outgoing_data = dict()
    except IOError as io_error:
        assert ovbx.con, "Error in opening %s: %s" % (io_error, url)

    if expectData:
        ovbx.current_page = None
        ovbx.current_page = ovbx.con.read()

    # Regardless of anything else, the connection should be closed.

    ovbx.con.close() 

    if expectData:
        assert ovbx.current_page, "Error in retrieving %s" % url


@step('I have accessed flow "(.*)"')
def i_access_flow(step, flow_number):
    flow_number = int(flow_number)
    page = "%s/twiml/applet/voice/%d/start" % (Config.Web.host, flow_number)
    assert_open_and_read(page)


@step('I handle a redirect')
def i_handle_a_redirect(step):
    root = etree.XML(ovbx.current_page)
    url = root.xpath('/Response/Redirect')[0].text
    assert url, "Got a badly formed response: %s" % ovbx.current_page
    assert_open_and_read(url)


@step('I follow the action')
def i_follow_the_action(step):
    current_page = ovbx.current_page
    root = etree.XML(ovbx.current_page)
    url = root.xpath('//@action')[0]
    assert url, "Got a badly formed response: %s" % ovbx.current_page
    assert_open_and_read(url)


@step('I should see "(.*)" is "(.*)"')
def i_should_see_blank_is_blank(step, element, value):
    root = etree.XML(ovbx.current_page)
    for element in root.xpath('//%s' % element):
        if element.text == value:
            return
        elif element.text.find(value):
            return
    current_page = ovbx.current_page
    assert False, 'No "%s" element with text: "%s"' % (element, value)


@step('I debug')
def i_debug (step):

    # Set these locally so they are easy to access

    cookie_jar = cj
    current_page = ovbx.current_page
    root = etree.XML(ovbx.current_page)

    for cookie in cookie_jar: # So we can see each cookie
        import pdb
        pdb.set_trace()


@step('I should see a "(.*)" element')
def i_should_see_a_blank_element(step, element):
    root = etree.XML(ovbx.current_page)
    assert root.xpath('//%s' % element), ("No '%s' element in present in:"
                                          % (element, ovbx_current_page))

def make_twilio_parameters():

    # TODO: Make this draw the values from the cookies set.

    return dict({('CallSid' if Config.Test.use_sid else 'CallGuid'):'NOT_VALID',
                 'AccountSid':'NOT_VALID',
                 'From':'NOT_VALID',
                 'To':'NOT_VALID',
                 'CallStatus':'NOT_VALID',
                 'ApiVersion':'NOT_VALID',
                 'Direction':'NOT_VALID',
                 'ForwardedFrom':'NOT_VALID'})


def make_transcribe_parameters():
    
    # This may or may not have to be elaborated on for the purposes of the
    # tests.

    return dict({'TranscriptionText':'NOT_FILLED',
                 'TranscriptionStatus':'completed',
                 'TranscriptionUrl':'NOT_FILLED',
                 'RecordingUrl':'NOT_FILLED'})


@step('I access the transcribe callback')
def i_access_the_transcribe_callback(step):
    root = etree.XML(ovbx.current_page)
    transcribe_url = root.xpath('//Record/@transcribeCallback')[0]
    assert transcribe_url, ("No transcribeCallback attribute found in : %s" %
                            ovbx.current_page)

    ovbx.outgoing_data.update(make_twilio_parameters())
    ovbx.outgoing_data.update(make_transcribe_parameters())

    assert_open_and_read(transcribe_url, expectData=False)


@step('I set param "(.*)" to "(.*)"')
def i_set_param_blank_to_blank(step, param, value):
   ovbx.outgoing_data.update({param:value}) 
