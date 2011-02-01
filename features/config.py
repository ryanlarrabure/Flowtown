class Config:

    class Test:

        use_sid = False


    class Web:

        host = 'http://vbxdev.local.twilio.com'


    class MySQL:

        dump_path = 'mysqldump'
        user = 'root'
        password = ''
        mysql = 'mysql'
        database = 'OpenVBX'
        backup_file = 'flows_backup.sql'
