@test
Feature: Create new Apimation project functionality

  Scenario: Create New project
    When I login apimation
    Then I create new project with name: SampleProject and type: basic
    And I create new environment:
      | Dev  |
      | PROD |
    Then I add global variables with parameters:
      | key        | value |
      | Test_var_1 | 123   |
      | Test_var_2 | 321   |
    And I delete all environments

  Scenario: Add new test collection
    When I login apimation
    Then I select project: SampleProject
    And I create new collection: TESTAPI with step: Apimation_login_Steps