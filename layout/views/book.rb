require 'services/book'
require 'json'

module AndrewNicolaou
  class Frontend
    module Views
      class Book < Layout
        def books
          isbns = ['9781843537830']
        end
        
        def book
          @book = BookProcessor.new.hash(@isbn)
          [@book]
        end
        
        def book_title
          @book[:title]
        end
        
        def book_author
          @book[:author]
        end
        
        def book_cover
          @book[:image]
        end
        
        def book_link
          @book[:link]
        end
      end
    end
  end
end 