Feature: User login

  Scenario: Successful admin login
    Given I am on the login page
    When I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "password"
    And I press "Log in"
    Then I should see "User Index"

  Scenario: Successful user login
    Given I am on the login page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "Log in"
    Then I should see "Welcome"

  Scenario: Unsuccessful login
    Given I am on the login page
    When I fill in "Email" with "wrong@example.com"
    And I fill in "Password" with "wrongpassword"
    And I press "Log in"
    Then I should see "Invalid email or password"
