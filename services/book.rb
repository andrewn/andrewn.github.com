require 'json'

class BookProcessor
  
  def initialize
  end
  
  def fetch_book_data(isbn, key="")
    unless @book_json
      search = query("/type/edition", "isbn_13", isbn)
      book_key    = search[0]["key"]
      @book_json = fetch(book_key)
    end
    @book_json[key.to_s] || ""
  end
  
  def fetch_author_data(isbn, key="")
    unless @author_json
      unless @book_json
        fetch_book_data(isbn)
      end
      author_key = @book_json["authors"][0]["key"]
      @author_json = fetch(author_key)
    end
    @author_json[key.to_s] || ""
  end
  
  def method_missing(key, *args)
    fetch_book_data(args, key)
  end
  
  def author(isbn)
    fetch_author_data(isbn, "name")
  end
  
  def image(isbn, size="S")
    "http://covers.openlibrary.org/b/isbn/#{isbn}-#{size}.jpg"
  end
  
  def html(isbn="")
    json(isbn)
  end
 
  def hash(isbn="")
    {
      :image  => image(isbn, "S"),
      :author => author(isbn),
      :title  => title(isbn),
      :link   => book_processor_url(isbn)
    }
  end
  
  def json(isbn)
    hash(isbn).to_json
  end
  
  private 
  require 'net/http'
  require 'uri'
  
  def api_get( url )
    response = Net::HTTP.get URI.parse( url )
    parsed_json = JSON.parse( response )
  end
  
  def query(type, key, value)
    url = "http://openlibrary.org/query.json?type=#{type}&#{key}=#{value}"
    api_get( url )
  end
  
  def fetch(path)
    url = "http://openlibrary.org#{path}"
    fetcher = url + ".json"
    response = api_get( fetcher )
    response["book_processor_url"] = url
    response
  end
end