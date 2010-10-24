require 'services/book'
require 'json'

module AndrewNicolaou
  class Frontend
    module Views
      class Book < Layout        
        def books
          @books.each do | book | 
            book.each_text_field do |key|
              book[key] = html_encode( book[key] )
            end
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