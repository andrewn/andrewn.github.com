Feature: Open projects area
    In order to see what Andrew can do
    As a cool company owner
    I want to find out about Andrew's projects

    Scenario: Visit projects area
        Given I am on the homepage
        When I activate 'Projects'
        Then the projects area should animate into view
    
    Scenario: Visit projects area without javascript
        Given I am on the homepage
        And javascript is disabled
        When I activate 'Projects'
        Then I should view the projects area