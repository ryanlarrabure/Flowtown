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
