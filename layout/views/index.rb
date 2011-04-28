module AndrewNicolaou
  class Frontend
    module Views      
      class Index < Post

        HELLO = "Hello!"

        def initialize
          @greetings = [
            HELLO, "Hola", HELLO, "Guten tag", HELLO, "Καλη μερά"
          ]
        end

        def user_friendly_date
          self[:date_object].strftime( '%d %b %Y' )
        end
        
        def title
          nil
        end

        def greeting
          greeting_id = rand( @greetings.length )
          @greetings[greeting_id]
        end

        require 'uri'
        require 'net/http'
        # TODO  Error handling (Exception, 404) and default include response
        #       for error conditions
        def bookmarks
          begin
            puts "Host: #{@host}"
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