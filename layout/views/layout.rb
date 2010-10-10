module AndrewNicolaou
  class Frontend
    module Views
      class Layout < Mustache
        def title
          @title || 'Andrew Nicolaou'
        end
      end
    end
  end
end