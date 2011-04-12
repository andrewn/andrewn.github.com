require 'date'
require 'yaml'
module AndrewNicolaou
  class Frontend
    module Views
      class Post < Layout
        
        @processed = false
        
        def initialize
          @contents = ''
        end
        
        def process!
          if @url.nil?
            return @contents
          end
          
          @spec = spec_for_url(@url)
          file_path = filepath_from_spec( @spec )
          format    = spec_for_filename( file_path )[:format]
          
          file_contents = File.open( file_path, "r" ) { |f| contents = f.read }
          
          @meta = meta_for_post_string(file_contents)
          
          # Remove YAML front matter from post
          if file_contents =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
            file_contents = file_contents[($1.size + $2.size)..-1]
          end
          
          case format
          when 'markdown'
            require 'bluecloth'
            parsed = BlueCloth.new( file_contents )
            @contents = parsed.to_html
          when 'textile'
            require 'redcloth'
            parsed = RedCloth.new( file_contents )
            @contents = parsed.to_html
          end
          
          @processed = true
        end
        
        def content
          process! unless @processed
          @contents
        end
        
        def title
          process! unless @processed
          @meta['title']
        end
        
        def more
          process! unless @processed
          @meta['morelinks']
        end
        
        def list(opts={})
          Dir['content/posts/*.*'].map do |item|
            
            spec = spec_for_filename( item )
            meta = meta_for_filename( item )
            
            spec[:url]   = url_for_spec( spec )
            spec[:title] = meta['title'] || nil
            spec[:meta]  = meta
 
            unless opts[:published].nil?
              spec = ( spec[:meta]['published'] == opts[:published] ) ? spec : nil
            end
             
            spec
            
          end.compact
        end
        
        def published
          list( :published => true )
        end
        
        def post_list
          @post_list
        end
        
        private 
        def spec_for_url(url)
          matcher = /([\d]{4})\/([\d]{2})\/([\d]{2})\/(.*)/
          url.match( matcher )
          {
            :year   => $1,
            :month  => $2,
            :date   => $3,
            :date_object => Date.civil( $1.to_i, $2.to_i, $3.to_i ),
            :slug   => $4          
          }
        end
        
        def spec_for_filename(filename)
          matcher = /([\d]{4})-([\d]{2})-([\d]{2})-(.*)[.](.*)/
          filename.match( matcher )
          {
            :year   => $1,
            :month  => $2,
            :date   => $3,
            :date_object => Date.civil( $1.to_i, $2.to_i, $3.to_i ),
            :slug   => $4,
            :format => $5,
            :title  => $4.gsub('-', ' ')
          }
        end
        
        def meta_for_filename( filename )
          # Parse into YAML node and transform into Ruby native objects
          meta_for_post_string( File.open( filename ) )
        end
        
        def meta_for_post_string( string )
          YAML::parse( string ).transform
        end
        
        def url_for_spec( spec )
          "/post/#{spec[:year]}/#{spec[:month]}/#{spec[:date]}/#{spec[:slug]}"
        end
        
        def filepath_from_spec( spec )
          filename = "content/posts/#{spec[:year]}-#{spec[:month]}-#{spec[:date]}-#{spec[:slug]}.*"
          Dir[ filename ].to_s
        end
        
      end
    end
  end
end