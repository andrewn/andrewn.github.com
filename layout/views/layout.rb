module AndrewNicolaou
  class Frontend
    module Views
      class Layout < Mustache
        def title
          @title || 'Andrew Nicolaou'
        end
        
        def page_id
          @page_id || nil
        end

        def logo_colour
          "white"
        end

      end
    end
  end
end