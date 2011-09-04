require 'layout/views/post'
module AndrewNicolaou
  class Frontend
    module Views      
      class PostList < Layout
          def posts
            @posts.map do |post|
              Post.new(post)
            end
          end
      end
    end
  end
end