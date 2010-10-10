module AndrewNicolaou
  class Frontend
    module Views
      class Page < Layout
        def content
          contents = ''
          file_path = @source
          File.open( file_path, "r" ) { |f| contents = f.read }
        end
      end
    end
  end
end