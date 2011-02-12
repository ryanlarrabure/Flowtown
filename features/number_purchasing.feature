Feature: OpenVBX Number Purchasing

    Scenario: I purchase a number
        Given I am on the homepage

        When I fill out the sign-in form
        And I click "//form[@class='vbx-login-form vbx-form']//button[@type='submit']"
        And I click "//a[@Title='Numbers']"
        And I JS click "//button[@class='add-button add number']"
        And I enter "480" into "area_code"
        And I JS click "//button[text()='Add number']"

        Then there should be no empty errors
        And I should either be given a number or an explanation

    Scenario: I purchase a number, no input
        Given I am on the homepage

        When I fill out the sign-in form
        And I click "//form[@class='vbx-login-form vbx-form']//button[@type='submit']"
        And I click "//a[@Title='Numbers']"
        And I JS click "//button[@class='add-button add number']"
        And I JS click "//button[text()='Add number']"

        Then there should be no empty errors
        And I should either be given a number or an explanation

    Scenario: I purchase a number international
        Given I am on the homepage

        When I fill out the sign-in form
        And I click "//form[@class='vbx-login-form vbx-form']//button[@type='submit']"
        And I click "//a[@Title='Numbers']"
        And I JS click "//button[@class='add-button add number']"
        And I JS click "//input[@value='tollfree']"
        And I JS click "//button[text()='Add number']"

        Then there should be no empty errors
        And I should either be given a number or an explanation
