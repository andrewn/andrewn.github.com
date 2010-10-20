require 'services/book'
require 'json'

module AndrewNicolaou
  class Frontend
    module Views
      class Book < Layout        
        def books
          @books
        end
      end
    end
  end
end 