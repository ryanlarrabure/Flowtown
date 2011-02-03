Feature: OpenVBX Menu Applet

    # The following scenario dies in menu/twiml.php, Line 18
    # And in libraries/AppletInstance.php, 281

    Scenario: Menu with 0 item, Flow 20 
        Given I have accessed flow "20"

        When I handle a redirect
        Then I should see a "Gather" element

    Scenario: Menu with 1 item, Flow 21
        Given I have accessed flow "21"

        When I handle a redirect
        And I press "1"

        When I handle a redirect
        Then I should see "Say" is "Hello World!"
    
    Scenario: Menu with 3 items, Flow 22
        Given I have accessed flow "22"

        When I handle a redirect
        Then I press "3"

        When I handle a redirect
        Then I should see "Say" is "Item 3"

    Scenario: More than 10 items, Flow 23 
        Given I have accessed flow "23"

        When I handle a redirect
        Then I press "11"

        When I handle a redirect
        Then I should see "Say" is "Item 11"

    Scenario: Redirect to voicemail, Flow 24
        Given I have accessed flow "24"

        When I handle a redirect
        Then I press "1"

        When I handle a redirect
        Then I should see a "Record" element

    Scenario: Handle Oops, Flow 25
        Given I have accessed flow "25"

        When I handle a redirect
        Then I press "2"

        Then I should see "Say" is "Oops fired"

    Scenario: Empty menu applet, Flow 26
        Given I have accessed flow "26"

        When I handle a redirect
        Then I should see a "Gather" element

    Scenario: Empty applet items for keypresses, Flow 28
        Given I have accessed flow "28"

        When I handle a redirect
        Then I press "1"
        And I should see "Say" is "You selected an incorrect option."

    Scenario: Handle 7, 77, and 777 as menu numbers, Flows 27
        Given I have accessed flow "27"

        When I handle a redirect
        Then I press "777"

        When I handle a redirect
        Then I should see "Say" is "I'm told this is jackpot"
