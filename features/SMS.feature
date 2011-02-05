Feature: OpenVBX SMS Applet

    Scenario: Send a SMS, Flow 29
        Given I have accessed flow "29"

        When I handle a redirect
        Then I should see "Sms" is "Hello World!"

    Scenario: Send a SMS with Voicemail, Flow 30
        Given I have accessed flow "30"

        When I handle a redirect
        Then I should see "Sms" is "Hello World!"
        
        When I handle a redirect
        Then I should see a "Record" element

    Scenario: SMS flow test send reply, Flow 31
        Given I have SMS accessed flow "31"

        When I handle a redirect
        Then I should see "Sms" is "Hello World!"

    Scenario: SMS flow with a empty applet, Flow 32
        Given I have SMS accessed flow "32"
        Then I should see a "Response" element

    Scenario: SMS flow with empty send reply, Flow 33
        Given I have SMS accessed flow "33"

        When I handle a redirect
        Then I should see "Sms" is empty

    Scenario: SMS empty menu flow, Flow 34
        Given I have SMS accessed flow "34"

        When I handle a redirect
        Then I should see "Sms" is empty

    Scenario: SMS Menu with 1 item, Flow 35
        Given I text "ping" to flow "35"

        When I handle a redirect
        Then I should see "Sms" is "pong"

    Scenario: SMS Menu with invalid option, Flow 35
        Given I text "nonsense" to flow "35"

        When I handle a redirect
        Then I should see "Sms" is empty

    Scenario: SMS Menu with greeting, Flow 36
        Given I have SMS accessed flow "36"

        When I handle a redirect
        I should see "Sms" is "Hello World!"

        When I clear my connection data
        And I text "ping" to flow "36"
        
        When I handle a redirect
        Then I should see "Sms" is "pong"

    Scenario: SMS inbox, Flow 37
        Given I text "Testing" to flow "37"

        When I handle a redirect
