require 'services/book'
require 'json'

module AndrewNicolaou
  class Frontend
    module Views
      class Book < Layout        
        def books
          @isbns.map do | isbn |
            b = BookProcessor.new.hash(isbn)
            b[:title].empty? ? nil : b
          end.compact!
        end
      end
    end
  end
end 