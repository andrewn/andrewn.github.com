module AndrewNicolaou
    module Models
        class Project
                # Returns an array of Project views
                def self.find_all(state=:published)
                  file_store = AndrewNicolaou::Models::FileStore.new("content/projects")
                  project_list = file_store.list("order_by_latest" => true)

                  if state == :published
                    project_list.find_all { |p| p["published"] != false }
                  elsif state == :unpublished
                    project_list.find_all { |p| p["published"] == false }
                  elsif state == :all
                    project_list
                  end
                end
        end
    end
end