import urllib2
import urllib
import cookielib
import subprocess
import re
import base64
import time

from lxml import etree
from lettuce import after, step, before
from selenium import selenium

from config import Config

class OpenVBX_Connection:
    
    def __init__ (self):
        self.con = None
        self.current_page = None
        self.current_url = None
        self.outgoing_data = dict() # Data to be sent in the next request
        self.outgoing_headers = dict()

        # Cookie handler and HTTP opener object

        self.cj = cookielib.CookieJar()
        self.opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(self.cj))



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

    # Dump the database

    args = []
    temp_file = open(Config.MySQL.backup_file, 'w')

    args = [Config.MySQL.dump_path, '-c', '--ignore-table=%s.settings' %
            Config.MySQL.database, '-u', Config.MySQL.user]
    if Config.MySQL.password:
        args += ['-p%s' % Config.MySQL.password]
    if Config.MySQL.host:
        args += ['--host=%s' % Config.MySQL.host]
    args += [Config.MySQL.database]
    proc = subprocess.Popen(args, stdout=temp_file)

    temp_file.flush()
    temp_file.close()


@after.all
def after_all(total):
    load_mysql_database(Config.MySQL.backup_file) # Load the backed up database


@before.each_scenario
def before_each_scenario(scenario):
    global sel

    # Setup our OpenVBX data holder

    global ovbx

    ovbx = OpenVBX_Connection() 
    sel = None


@after.each_scenario
def after_each_scenario(scenario):
    global ovbx
    global sel

    ovbx = None # Destroy our OpenVBX container
    if sel and Config.Selenium.close_after_scenario:
        sel.close()
    sel = None


def assert_open_and_read(url, expectData=True):

    # This opens, reads, sets the current page object, and asserts that the
    # page is not empty.

    if ovbx.con:
        ovbx.con.close()
        ovbx.con = None
    try:
        request = urllib2.Request(url)
        if ovbx.outgoing_headers:
            if len(ovbx.outgoing_headers) > 1:
                for header, value in ovbx.outgoing_headers.keys(), \
                                    ovbx.outgoing_headers.values():
                    request.add_header(header, value)
            else:
                    request.add_header(ovbx.outgoing_headers.keys()[0],
                                       ovbx.outgoing_headers.values()[0])
            ovbx.outgoing_headers = dict()
        if ovbx.outgoing_data:
            ovbx.con = ovbx.opener.open(request,
            urllib.urlencode(ovbx.outgoing_data))
            ovbx.outgoing_data = dict()
        else:
            ovbx.con = ovbx.opener.open(request)
        ovbx.current_url = url
    except IOError as io_error:
        assert ovbx.con, "Error in opening %s: %s" % (io_error, url)

    if expectData:
        ovbx.current_page = None
        ovbx.current_page = ovbx.con.read()

    # Regardless of anything else, the connection should be closed.

    ovbx.con.close() 

    if expectData:
        assert ovbx.current_page, "Error in retrieving %s" % url


def assert_text_present(element_string):
    assert sel.get_text(element_string), "Empty element string at %s" % \
                                         element_string


def assert_compare_element_text(element_string, text, regexp=False):
    retrieved_text = sel.get_text(element_string)
    if regexp:
        assert re.match(text, retrieved_text), \
               '"%s" does not match "%s"' % (text, retrieved_text)
    else:
        assert retrieved_text == text, \
               '"%s" does not equal "%s"' % (text, retrieved_text)


def assert_element_present(element_string):
    assert sel.is_element_present(element_string), \
           'Could not find element "%s"' % element_string


def assert_element_visible(element_string):
    assert sel.is_visible(element_string), 'Element "%s" is not visible' % \
           element_string


def assert_element_present_and_visible(element_string):
    assert_element_present(element_string)
    assert_element_visible(element_string)


@step(u'Given I am on the homepage')
def given_i_am_on_the_homepage(step):
    global sel

    sel = selenium(Config.Selenium.host, Config.Selenium.port,
                   Config.Selenium.browser, Config.Web.host)
    sel.start()
    if Config.Web.use_auth and Config.Web.username and Config.Web.password: 
        sel.addCustomRequestHeader('Authorization', 'Basic %s' %
                                         base64.encodestring("%s:%s" % 
                                            (Config.Web.username,
                                            Config.Web.password)).strip())
    sel.open(Config.Web.path_to_openvbx)


@step(u'the title should start with "(.*)"')
def the_title_should_start_with_STRING(step, search_string):
    title = sel.get_title()
    assert title.startswith(search_string), \
           '"%s" doesn\'t start with "%s"' % (search_string, title)


@step('I have accessed flow "(.*)"')
def i_access_flow(step, flow_number):
    flow_number = int(flow_number)
    page = "%s%s/twiml/applet/voice/%d/start" % (Config.Web.host,
        Config.Web.path_to_openvbx, flow_number)
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
        elif element.text.find(value) is not -1:
            return
    assert False, 'No "%s" element with text: "%s"' % (element, value)


@step('I should see "(.*)" is empty')
def i_should_see_blank_is_empty(step, element):
    root = etree.XML(ovbx.current_page)
    for element in root.xpath('//%s' % element):
        if not element.text:
            return
    assert False, 'No "%s" element is empty' % element 


@step(u'I click "(.*)"')
def i_click_STRING(step, link):
    sel.click(link)
    sel.wait_for_page_to_load(Config.Selenium.page_load_MS)


@step(u'I JS click "(.*)"')
def i_JS_click_STRING(step, link):

    # Use this when it triggers a javascript action, not for opening a link

    sel.click(link)

@step('I debug')
def i_debug (step):

    # Set these locally so they are easy to access

    cookie_jar = ovbx.cj
    current_page = ovbx.current_page
    #root = etree.XML(ovbx.current_page)
    o = ovbx

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

    return dict({'TranscriptionText':'NOT_VALID',
                 'TranscriptionStatus':'completed',
                 'TranscriptionUrl':'NOT_VALID',
                 'RecordingUrl':'NOT_VALID'})


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


@step('I press "(.*)"')
def i_press_blank(step, number):
    ovbx.outgoing_data.update(make_twilio_parameters())
    ovbx.outgoing_data.update({"Digits":number})
    assert_open_and_read(ovbx.current_url)


def make_SMS_parameters():
    return dict({'SmsSid':'NOT_VALID',
                 'AccountSid':'NOT_VALID',
                 'From':'+15555555555',
                 'To':'+15555555556',
                 'Body':'NOT_VALID'})


@step('I have SMS accessed flow "(.*)"')
def i_have_SMS_accessed_flow_blank(step, flow_number):
    ovbx.outgoing_data.update(make_SMS_parameters())
    flow_number = int(flow_number)
    page = "%s%s/twiml/applet/sms/%d/start" % (Config.Web.host,
        Config.Web.path_to_openvbx, flow_number)
    assert_open_and_read(page)


@step('I text "(.*)" to flow "(.*)"')
def i_text_blank(step, text, flow_number):
    ovbx.outgoing_data.update(make_SMS_parameters())
    flow_number = int(flow_number)
    page = "%s%s/twiml/applet/sms/%d/start" % (Config.Web.host,
        Config.Web.path_to_openvbx, flow_number)
    ovbx.outgoing_data.update(dict({'Body':text}))
    assert_open_and_read(page)


@step('I check the inbox')
def i_check_the_inbox(step):
    ovbx.outgoing_data.update(dict({"email":Config.Web.username,
                                   "pw":Config.Web.password,
                                   "login":"1"}))
    assert_open_and_read("%s%s/auth/login?redirect=" % (Config.Web.host,
        Config.Web.path_to_openvbx))

    ovbx.outgoing_headers.update(dict({'Accept':'application/json'}))

    assert_open_and_read("%s%s/messages/inbox" % (Config.Web.host,
        Config.Web.path_to_openvbx))


@step('I clear my connection data')
def i_clear_my_connection_data(step):
    global ovbx

    ovbx = None
    ovbx = OpenVBX_Connection()

@step('I fill out the sign-in form')
def i_fill_out_the_sign_in_form(step):
    assert_element_present_and_visible('//input[@name="email"]')
    assert_element_present_and_visible('//input[@name="pw"]')
    sel.type('email', Config.Web.username)
    sel.type('pw', Config.Web.password)

@step('I enter "(.*)" into "(.*)"')
def i_enter_BLANK_into_BLANK(step, value, key):
   sel.type(key, value) 


def poll(function, max_wait_in_ms=5000, increment_in_ms=250):

    # If the function passed evaluates True, return its value

    amassed_time = 0
    r = None
    while amassed_time <= max_wait_in_ms:
        r = function()
        if r:
            return r
        time.sleep(increment_in_ms/1000)
        amassed_time += increment_in_ms
    return r


@step('there should be no empty errors')
def there_should_be_no_empty_errors(step):

    if poll(lambda: sel.is_element_present(
        "//div[@id='dlg_add']/div[@class='hide error-message' and @style]"),
        (10*1000), 250):
        assert sel.get_text(
            "//div[@id='dlg_add']/div[@class='hide error-message']"), (
            "Error: Got an empty error message")

@step('I should either be given a number or an explanation')
def i_should_either_be_given_a_number_or_an_explanation(step):
    found = False
    text = sel.get_text(
    "//div[@id='dlg_add']/div[@class='hide error-message']")
    if text == "No phone numbers found":
        found = True
    if not found:
        found = sel.is_element_present("//div[@id='completed-order']")
    assert found, "Error: Got neither an explanation or a number."
