require 'rubygems'
require 'hpricot'
require 'open-uri'

class PinboardProcessor

  attr_reader :html

  @@no_title_text = "(No title)"
  @html
  
  def initialize    
    limit = 5
    html_template = '<li><a href="{link}">{title}</a></li>'
    rss_url = "http://feeds.pinboard.in/rss/u:andrewn"
    proxy = nil
    
    begin
      doc = open(rss_url, :proxy => proxy) { |f| Hpricot::XML(f) }
      children = doc.search("//item").slice(0 , limit)
      @html = create_html_from_rss_items( children, html_template )
    rescue Exception
      warn "PinboardProcessor: Exception fetching data"
      @html = "<p>No bookmarks available.</p>"
    end
  end
  
  def html(params={})
    @html
  end

  def create_html_from_rss_items( items, template )
    output = ""
    items.each do | item |
      title = item.at( "title" ).inner_html
      url   = item.at( "link" ).inner_html  
      output << replace_in_template_string( template, { :title => title, :link => url } )
    end
    return output
  end
  
  def replace_in_template_string( str="", hash={} ) 
    
    if hash[:title].nil? or hash[:title].empty?
      return ""
      hash[:title] = @@no_title_text
    end
    
    output = str.clone
    patterns = str.scan( /\{[\w]+\}/i )
    patterns.each do | pattern |
      pattern_as_symbol = pattern.gsub( /[\{\}]/, "" ).intern
      output.gsub!( pattern, hash[ pattern_as_symbol ] ) unless hash[ pattern_as_symbol ].nil?
    end
    return output
  end
end

puts "<ol>" + PinboardProcessor.new.html + "</ol>"