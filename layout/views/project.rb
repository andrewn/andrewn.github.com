require File.dirname(__FILE__) + '/../../models/file_store.rb'
module AndrewNicolaou
  class Frontend
    module Views
      class Project < Layout
        
        attr_accessor :name, :description, :link
        
        def initialize(content={})
          p content
          @name     = content["title"]
          @tech     = content["tech"]
          @description  = content["content"]
          @link = []

          if content["link"]
            content["link"].each_with_index do |l,i|
              @link << {
                'name'=> content["link"][i],
                'url' => content["link"][i + 1]
              } if (i % 2) == 0
            end
          end
        end

        def tech
          items = []
          last_index = @tech.length - 1
          @tech.each_with_index { |item, index| 
            items_hash = { 
              "item"  => item, 
              "last?" => (last_index == index)
            }
            items.push(items_hash)
          }
          return items
        end

        def summary
          @description.to_a[0]
        end
      end
    end
  end
end