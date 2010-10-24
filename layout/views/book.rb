require 'services/book'
require 'json'

module AndrewNicolaou
  class Frontend
    module Views
      class Book < Layout        
        def books
          @books.each do | book | 
            p book.author
            book.author = html_encode( book.author )
            p book.author
          end
        end
        
        require 'htmlentities'
        require 'unicode'
        $KCODE = 'UTF-8'
        def html_encode( str )
          coder = HTMLEntities.new
          coder.encode( str, :named )
        end
      end
    end
  end
end 