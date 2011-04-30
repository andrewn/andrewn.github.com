Feature: Show project detail
    In order to see what Andrew can do
    As a cool company owner
    I want to find out about Andrew's projects
    
    Scenario: Access project detail
        Given the project area is open
        When I click on the project
        Then the page should transition to the project detail
    
    Scenario: View project detail
        Given I am on a project detail
        Then I should see the project title
        And project images
        And the technologies used
        And a detailed description
        And the client
