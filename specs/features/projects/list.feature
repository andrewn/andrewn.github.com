Feature: List projects
    In order to see what Andrew can do
    As a cool company owner
    I want to find out about Andrew's projects
    
    Scenario: Default list view
        Given the project area is open
        When I view the list of projects
        Then they should be in chronological order

    Scenario: Project meta data
        Given the project area is open
        When I view a project
        Then I should see a project thumbnail
        And the project title
        And the client
        And a list of technologies used