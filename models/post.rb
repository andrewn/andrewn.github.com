module AndrewNicolaou
    module Models
        class Post
                # Returns an array of Post views
                def self.find_all(state=:published)
                  file_store = AndrewNicolaou::Models::FileStore.new("content/posts")
                  post_list = file_store.list("order_by_latest" => true)

                  if state == :published
                    post_list.find_all { |p| p["published"] != false }
                  elsif state == :unpublished
                    post_list.find_all { |p| p["published"] == false }
                  elsif state == :all
                    post_list
                  end
                end

                def self.latest(num=1)
                  self.find_all.slice(0,num)
                end

                def self.find_by_slug(slug)
                  file_store = AndrewNicolaou::Models::FileStore.new("content/posts")
                  post_list = file_store.list("order_by_latest" => true).find do |post|
                    post["slug"] === slug
                  end
                end                  
        end
    end
end