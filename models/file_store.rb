require 'date'
require 'yaml'
module AndrewNicolaou
  module Models
    # FileStore is a class that understands files that use a Sinatra-style
    # markdown + YAML front-matter combo
    # It's designed to be wrapped by other classes.
    class FileStore

      @base_file_path = ""

      def initialize(base_file_path)
        @base_file_path = base_file_path
      end

      def list(opts={})
        file_contents = file_list

        if opts["order_by_latest"]
          file_contents.reverse!
          # file_contents = file_contents.sort { |a,b| 
          #    a["date"] <=> b["date"]
          # }
        end

        file_contents
      end

      private 
      def file_list(opts={})
        dir_path = "#{@base_file_path}/*.*"
        Dir[dir_path].map do |file_name|
          begin
            filename_metadata = parse_filename_to_metadata( file_name )

            file_contents     = parse_content_from_file( file_name )
            file_contents["date"] = filename_metadata[:date_object]
            file_contents["slug"] = filename_metadata[:slug]

            file_contents
          rescue
            # do nothing on error
          end
        end.compact
      end

      def parse_content_from_file(file_path)
        format  = parse_filename_to_metadata( file_path )[:format]
        file_contents = File.open( file_path, "r" ) { |f| contents = f.read }
        file_metadata = parse_metadata_from_string(file_contents)
        
        # Remove YAML front matter from post
        if file_contents =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          file_contents = file_contents[($1.size + $2.size)..-1]
        end

        format = 'markdown' if format == 'txt'
        
        case format
        when 'markdown'
          require 'bluecloth'
          parsed = BlueCloth.new( file_contents )
          contents = parsed.to_html
        when 'textile'
          require 'redcloth'
          parsed = RedCloth.new( file_contents )
          contents = parsed.to_html
        end

        data = {}
        data.merge!(file_metadata)
        data['content'] = contents
        return data
      end
    
      def parse_url_to_metadata(url)
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
      
      def parse_filename_to_metadata(filename)
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
      
      def parse_metadata_from_file( filename )
        # Parse into YAML node and transform into Ruby native objects
        parse_metadata_from_string( File.open( filename ) )
      end
      
      def parse_metadata_from_string( string )
        YAML::parse( string ).transform
      end
      
      def url_from_metadata( spec )
        "/post/#{spec[:year]}/#{spec[:month]}/#{spec[:date]}/#{spec[:slug]}"
      end
      
      def filepath_from_metadata( spec )
        filename = "#{@base_file_path}/#{spec[:year]}-#{spec[:month]}-#{spec[:date]}-#{spec[:slug]}.*"
        Dir[ filename ].to_s
      end
     end
  end
end