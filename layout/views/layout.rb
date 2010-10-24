module AndrewNicolaou
  class Frontend
    module Views
      class Layout < Mustache
        def title
          @title || 'Andrew Nicolaou'
        end
        
        def page_id
          @page_id || ""
        end
      end
    end
  end
end