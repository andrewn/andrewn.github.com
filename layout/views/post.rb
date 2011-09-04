# TODO: Convert to use filestore
require 'date'
require 'yaml'
module AndrewNicolaou
  class Frontend
    module Views
      class Post < Layout
          def initialize(content={})
            @content = content
            @date    = @content["date"]
          end
          def title
            @content['title']
          end
          def url
            "/posts/#{@content['slug']}"
          end
          def short_date
            @date.strftime("%a %d %b %Y")
          end
          def machine_short_date
            @date.strftime("%Y-%m-%d")
          end
      end
    end
  end
end