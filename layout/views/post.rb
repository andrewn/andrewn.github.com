module AndrewNicolaou
  class Frontend
    module Views
      class Post < Layout
          def initialize(content={})
            @content = content
            puts "Initialize new Post object"
            p @content
          end
          def date
            d = @content["date"] || @post["date"]
            puts "Date requested #{d}"
            return d
          end
          def title
            @content['title'] || @post['title']
          end
          def content
            @content['content'] || @post['content']
          end
          def summary
            para = content.to_a[0]
            para.gsub!(/(<a[^<]*>|<\/a>)/, '')
            para.gsub!(/<\/?p>/, '')
            para
          end
          def url
            "/posts/#{@content['slug']}"
          end
          def short_date
            date.strftime("%a %d %b %Y")
          end
          def machine_short_date
            date.strftime("%Y-%m-%d")
          end
      end
    end
  end
end