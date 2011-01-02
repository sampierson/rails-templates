
Feature: Authentication

  Scenario: Sign Up
    Given I am logged out
    And I go to the home page
    Then I should see "Sign up"
    When I follow "Sign up"
    And I fill in "Email address" with "user@example.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Sign up"
    Then I should be on the sign in page
    And I should see "You have registered successfully"

  Scenario: Confirmation
    Given I sign up with email "user@example.com" and password "password"
    And I go to the confirmation link for user "user@example.com"
    Then I should see "account was successfully confirmed"
    
  Scenario: Sign In
    Given there exists a confirmed user with email "user@example.com" and password "password"
    And I am logged out
    And I go to the sign in page
    And I fill in "Email address" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should be on the home page
    And I should see "Signed in successfully"

  Scenario: Sign Out
    Given there exists a confirmed user with email "user@example.com" and password "password"
    And I sign in as "user@example.com" with password "password"
    Then I should see "Sign out"
    When I follow "Sign out"
    Then I should be on the home page
    And I should see "Signed out successfully"
