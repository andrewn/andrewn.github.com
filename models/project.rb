module AndrewNicolaou
    module Models
        class Project
                # Returns an array of Project views
                def self.find_all
                  file_store = AndrewNicolaou::Models::FileStore.new("content/projects")
                  file_store.list("order_by_latest" => true)
                end
        end
    end
end