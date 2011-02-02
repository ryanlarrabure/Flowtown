Feature: Voicemail Applet

    Scenario: Empty Voicemail, Flow 16
        Given I have accessed flow "16"

        When I handle a redirect
        Then I should see "Say" is "Please leave a message."
        And I should see a "Record" element

    Scenario: Voicemail with text, Flow 17
        Given I have accessed flow "17"

        When I handle a redirect
        Then I should see "Say" is "I'm reading text like a robot."
        And I should see a "Record" element
        And I debug
