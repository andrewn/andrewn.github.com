require 'layout/views/post'
module AndrewNicolaou
  class Frontend
    module Views      
      class PostList < Layout
          def posts
            puts "PostList #{@posts.length}"
            @posts.map do |post|
              puts "List #{post}"
              Post.new(post)
            end
          end
      end
    end
  end
end