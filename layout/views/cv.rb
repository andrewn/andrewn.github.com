module AndrewNicolaou
  class Frontend
    module Views      
      class Cv < Layout
        def logo_colour
          "black"
        end

        def extended?
            @extended.nil? ? false : @extended
        end
      end
    end
  end
end