class Config:

    class Test:

        use_sid = False


    class Web:

        host = 'http://www.example.com'
        path_to_openvbx = '/OpenVBX'
        username = 'ryan+openvbxtest@asdfsa.inv'
        password = 'testing'
        use_auth = False

    class Selenium:
        
        host = "localhost"
        port = "4444"
        browser = "*firefox"
        close_after_scenario = False

        page_load_MS = 120 * 1000


    class MySQL:

        perform_dump = False
        dump_path = 'mysqldump' # Not used at the moment
        host ='' # This isn't used either
        user = 'ryan'
        password = ''
        mysql = 'mysql'
        database = 'OpenVBX'
        backup_file = 'flows_backup.sql'
