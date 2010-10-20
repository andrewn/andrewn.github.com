module AndrewNicolaou
  module Models

    require 'rubygems'
    require 'net/http'
    require 'uri'
    require 'json'
    
    class LibraryService
      def self.find_by_isbn( isbn )
        return nil
      end
      
      def self.http_get( url )
        Net::HTTP.get URI.parse( url )
      end
      
      def self.from_json( response )
        JSON.parse( response )
      end
    end
    
    class OpenLibrary < LibraryService
      def self.find_by_isbn( isbn ) 
        begin
          search = query("/type/edition", "isbn_13", isbn)
          if search and search[0] and search[0]["key"]
            book_key  = search[0]["key"]
            book_data = fetch(book_key)
            if book_data["title"]
              b = Book.new
              b.title  = book_data["title"]
              b.author = author_by_open_library( book_data )["name"]
              b.cover  = "http://covers.openlibrary.org/b/isbn/#{isbn}-S.jpg"
            else
              b = nil
            end
          else
            puts "MISS: #{isbn}"
          end
          return b
        rescue Exception
          puts "Exception in OpenLibrary, returning nil"
          nil
        end
      end
      
      def self.author_by_open_library( data )
        author_key = data["authors"][0]["key"]
        fetch(author_key)
      end
      
      def self.query( type, key, value )
        url = "http://openlibrary.org/query.json?type=#{type}&#{key}=#{value}"
        from_json( http_get( url ) )
      end
      
      def self.fetch( path )
        url = "http://openlibrary.org#{path}"
        fetcher = url + ".json"
        response = from_json( http_get( fetcher ) )
        response["book_processor_url"] = url
        response
      end
    end
    
    class LibraryThing < LibraryService
    end
    
    class GoogleBooks < LibraryService
      require 'hpricot'
      def self.find_by_isbn( isbn )
        begin
          url = "http://books.google.com/books/feeds/volumes?q=#{isbn}"
          xml_response = http_get( url )
          # title
          # dc:creator
          # <link rel="http://schemas.google.com/books/2008/thumbnail" type="image/x-unknown" href="http://bks7.books.google.com/books?id=olV0PQAACAAJ&amp;printsec=frontcover&amp;img=1&amp;zoom=5&amp;sig=ACfU3U21_QjHw-K2x5HDv8TTLC80c-4_gg&amp;source=gbs_gdata"/>
          doc = Hpricot( xml_response )
          entry = doc.search("entry")
        
          title  = entry.search("title").inner_html
          author = entry.search("dc:creator").inner_html
          # //link[@rel="http://schemas.google.com/books/2008/thumbnail"]
          cover_entry = entry.search('//link[@rel="http://schemas.google.com/books/2008/thumbnail"]')
        
          if cover_entry.first
            cover = cover_entry.first['href']
          else
            cover  = ""
          end
        
          b = Book.new
          b.title  = title
          b.author = author
          b.cover  = cover
          
          puts "Found GoogleBooks, returning #{b}"
          
          return b
        rescue Exception
          puts "Exception in GoogleBooks, returning nil"
          nil
        end
      end
    end
    
    class Book
      attr_accessor :title, :author, :cover
      @available_services = [ OpenLibrary, GoogleBooks ]
      def self.find_by_isbn( isbn = "" )
        
        isbn.gsub!(/[- ]/, '')
        
        found_book = nil
        found_book = @available_services.map do | service | 
          book = service.find_by_isbn( isbn )
          unless book.nil? 
            return book
          end
        end 
        found_book
      end
    end
    
    def to_h
      {
        :title => title,
        :author=> author,
        :cover => cover
      }
    end
    
  end
end