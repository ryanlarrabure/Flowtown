Feature: OpenVBX Dial Applet

    Scenario: Dial a number, Flow 2
        Given I have accessed flow "2"
        When I handle a redirect
        Then I should see "Number" is "15105555555"
        When I follow the action
        And I handle a redirect
        Then I should see a "Hangup" element
    
    Scenario: Dial a user, Flow 3
        Given I have accessed flow "3"
        When I handle a redirect
        Then I should see "Number" is "15105555555"
        When I follow the action
        And I handle a redirect
        Then I should see a "Hangup" element

    Scenario: Dial Sales Group, Flow 5
        Given I have accessed flow "5"
        When I handle a redirect
        Then I should see "Number" is "15105555555"
        When I follow the action
        Then I should see "Number" is "15105555555"
        When I follow the action
        Then I should see "Say" is "Please leave a message."
        And I should see a "Record" element
        When I access the transcribe callback

    Scenario: Dial an Invalid number, Flow 6
        Given I have accessed flow "6"
        When I handle a redirect
        Then I should see "Number" is "12323456789"
        When I set param "DialCallStatus" to "failed"
        And I follow the action
        Then I should see a "Hangup" element

    Scenario: Empty dial, Flow 7
        Given I have accessed flow "7"
        When I handle a redirect
        Then I should see "Say" is "Missing user or group to dial"

    Scenario: Busy, Flow 2
        Given I have accessed flow "2"
        When I handle a redirect
        And I set param "DialCallStatus" to "busy"
        And I handle a redirect
        Then I should see a "Hangup" element

    Scenario: Answered, Flow 2
        Given I have accessed flow "2"
        When I handle a redirect
        And I set param "DialCallStatus" to "completed"
        And I handle a redirect
        Then I should see a "Hangup" element

    Scenario: No answer, Flow 2
        Given I have accessed flow "2"
        When I handle a redirect
        And I set param "DialCallStatus" to "no-answer"
        And I handle a redirect
        Then I should see a "Hangup" element

