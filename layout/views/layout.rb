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
      end
    end
  end
end