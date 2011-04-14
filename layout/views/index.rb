module AndrewNicolaou
  class Frontend
    module Views      
      class Index < Post
        
        def user_friendly_date
          self[:date_object].strftime( '%d %b %Y' )
        end
        
        def title
          nil
        end

        @greetings = [
          "Hola", "Guten tag", "Hello", "Καλη μερά"
        ]

        def greeting
          "Hola"
        end

        require 'uri'
        require 'net/http'
        # TODO  Error handling (Exception, 404) and default include response
        #       for error conditions
        def bookmarks
          begin
            Net::HTTP.get( URI.parse("#{@host}/service/pinboard") )
          rescue Exception
            ""
          end
        end
        
        def posts
          list = AndrewNicolaou::Frontend::Views::Post.new.list(:published => true)          
          {
            :list => list
          }
        end
      end
    end
  end
end