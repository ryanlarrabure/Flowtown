Feature: OpenVBX Menu Applet

    # The following scenario dies in menu/twiml.php, Line 18
    # And in libraries/AppletInstance.php, 281

    Scenario: Menu with 0 item, Flow 14
        Given I have accessed flow "14"
        When I handle a redirect

    Scenario: Menu with 1 item, Flow 15
        Given I have accessed flow "15"
        When I handle a redirect
        And I press "1"
        Then I debug
