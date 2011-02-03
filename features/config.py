class Config:

    class Test:

        use_sid = False


    class Web:

        host = 'http://vbxdev.local.twilio.com'


    class MySQL:

        dump_path = 'mysqldump' # Not used at the moment
        host ='' # This isn't used either
        user = 'root'
        password = ''
        mysql = 'mysql'
        database = 'vbx2008'
        backup_file = 'flows_backup.sql'
