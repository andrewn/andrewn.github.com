require  File.dirname(__FILE__) + '/post'
puts "File path " + File.dirname(__FILE__)
puts "Loading static postlist class"
module AndrewNicolaou
  class Frontend
    module Views      
      class PostList < Layout
          def initialize 
            puts "Initializing PostList"
          end
          def posts
            puts "PostList #{@post_list.length}"
            @post_list.map do |post|
              puts "List #{post}"
              Post.new(post)
            end
          end
      end
    end
  end
end