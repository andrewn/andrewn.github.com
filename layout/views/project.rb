require File.dirname(__FILE__) + '/../../models/file_store.rb'
module AndrewNicolaou
  class Frontend
    module Views
      class Project < Layout
        
        attr_accessor :name, :description, :link, :slug, :has_thumbnail, :date
        
        def initialize(content={})
          @name           = content["title"]
          @tech           = content["tech"]
          @description    = content["content"]
          @link           = []
          @slug           = content["slug"]
          @has_thumbnail  = content['thumbnail'].nil? ? true : content['thumbnail']
          #@meta           = content
          @date           = content["date"]

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

        def thumbnail
          "#{@slug}-thumb.png"
        end

        def has_thumbnail?
          @has_thumbnail
        end

        def when
          time_in_words = distance_of_time_in_words(Time.parse(@date.to_s), Time.now)
          time_in_words.capitalize!
          {
            :item => time_in_words + ' ago'
          }
        end

        def summary
          @description.to_a[0]
        end

        def locale(key, opts)
          count = opts[:count]
          tags = {
            :x_days => {
                :one   =>   "1 day",
                :other => "%{count} days"
              },
            :about_x_months => {
              :one   => "about 1 month",
              :other => "about %{count} months"
            },
            :x_months => {
              :one  =>   "1 month",
              :other => "%{count} months"
            },
            :about_x_years => {
              :one =>   "about 1 year",
              :other => "about %{count} years"
            },
            :over_x_years => {
              :one =>   "over 1 year",
              :other => "over %{count} years"
            },
            :almost_x_years => {
              :one =>   "almost 1 year",
              :other => "almost %{count} years"   
            }         
          }

          if tags[key]
            if count == 1
              return tags[key][:one]
            else
              return tags[key][:other].gsub(/\%\{count\}/, count.to_s)
            end
          else
            return ""
          end
        end

        # From Rails http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-distance_of_time_in_words
        #   actionpack/lib/action_view/helpers/date_helper.rb
        def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, options = {})
          from_time = from_time.to_time if from_time.respond_to?(:to_time)
          to_time = to_time.to_time if to_time.respond_to?(:to_time)
          distance_in_minutes = (((to_time - from_time).abs)/60).round
          distance_in_seconds = ((to_time - from_time).abs).round

          case distance_in_minutes
    
            when 1440..2529      then locale :x_days,         :count => 1
            when 2530..43199     then locale :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
            when 43200..86399    then locale :about_x_months, :count => 1
            when 86400..525599   then locale :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
            else
              distance_in_years           = distance_in_minutes / 525600
              minute_offset_for_leap_year = (distance_in_years / 4) * 1440
              remainder                   = ((distance_in_minutes - minute_offset_for_leap_year) % 525600)
              if remainder < 131400
                locale(:about_x_years,  :count => distance_in_years)
              elsif remainder < 394200
                locale(:over_x_years,   :count => distance_in_years)
              else
                locale(:almost_x_years, :count => distance_in_years + 1)
              end
          end
        end

      end
    end
  end
end