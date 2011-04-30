Feature: Homepage greeting
    As a visitor
    In order to be welcomed to the site
    I want to see a greeting

    Scenario: See greeting
        When I visit the homepage
        Then I should see a greeting 
        And the greeting should be one of the supported greetings

    Scenario: Greeting should change on load
        When I visit the homepage multiple times
        Then the greeting should change