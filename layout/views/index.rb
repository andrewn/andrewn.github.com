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