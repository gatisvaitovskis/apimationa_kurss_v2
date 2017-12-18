Feature: Login steps

  Scenario: Positive login
    When I login apimation
    Then I can access my info

  Scenario: Negative login
    When I try to log in apimation.com with a wrong password
    Then I check if I am not logged in and I cannot access my data