Feature: Monthly view
    In order to see what's been read in a month
    I want to get a list of books for a specific month

    Scenario: Show for month
        When I visit 'March' that has books
        Then I should see a list of 3 books

    Scenario: Month has no books
        When I visit 'March' that has no books
        Then I should see the message 'No books read in March. Bad Andrew.'
        And no books should be listed

    Scenario: Month is in future
        Given the current year is 2011
        And the current month is May
        When I visit 'June'
        Then I should see the message ''

    Scenario: Month doesn't exist
        When I visit month number '13'
        Then I should get a '404'