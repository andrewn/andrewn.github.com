module AndrewNicolaou
  class Frontend
    module Views      
      class Index < Post

        HELLO = "Hello!"

        def initialize
          if @multi_lang_greetings
            @greetings = [
              HELLO, "Hola", HELLO, "Guten tag", HELLO, "Καλη μερά"
            ]
          else
            @greetings = [HELLO]
          end
        end

        def user_friendly_date
          self[:date_object].strftime( '%d %b %Y' )
        end
        
        def title
          nil
        end

        def show_intro
          @show_intro.nil? ? true : @show_intro
        end

        def project_scope
          @project_scope.nil? ? "Recent" : @project_scope
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
          return nil unless @posts_list
          @posts_list.map do |post|
            Post.new post
          end
        end

        def page_id
          "home"
        end
      end
    end
  end
end