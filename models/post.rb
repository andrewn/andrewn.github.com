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
        end
    end
end