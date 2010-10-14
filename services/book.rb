require 'json'

class BookProcessor
  
  def initialize
  end
  
  def fetch_book_data(isbn, key)
    unless @book_json
      api_get(isbn)
    end
    @book_json[key.to_s] || ""
  end
  
  def method_missing(key, *args)
    fetch_book_data(args, key)
  end
  
  def image(isbn, size="S")
    "http://covers.openlibrary.org/b/isbn/#{isbn}-#{size}.jpg"
  end
  
  def html(isbn="")
    {
      :image  => image(isbn, "M"),
      :author => author(isbn),
      :title  => title(isbn)
    }.to_json
  end
  
  private 
  def api_get(isbn)
    require 'net/http'
    require 'uri'
    response = Net::HTTP.get URI.parse("http://openlibrary.org/query.json?type=/type/edition&isbn_13=#{isbn}")
    query_json = JSON.parse( response )
    
    book_key = query_json[0]["key"]
    book_url = "http://openlibrary.org#{book_key}.json"
    book_response = Net::HTTP.get URI.parse(book_url)
    @book_json = JSON.parse( book_response )
  end
end