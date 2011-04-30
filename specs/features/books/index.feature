Feature: Books index
    In order to see what Andrew's been reading recently
    I want to get a list of read items (books)

    Scenario: List read items
        When I visit the books index at "/read"
        Then I should see a list of recently read books

    Scenario: Read item
        When I see an individual item in the index
        Then it should have a title
        And it may have a thumbnail
        And it should have an author