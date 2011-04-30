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

        def page_title
          title.nil? ? "Andrew Nicolaou" : title
        end

        def greeting
          greeting_id = rand( @greetings.length )
          @greetings[greeting_id]
        end

        def projects
          @projects_list.map { |project| 
            Project.new( project )
          }
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