require 'rubygems'
require 'hpricot'
require 'open-uri'

class Processor

  attr_reader :html

  @@no_title_text = "(No title)"
  @html
  
  def initialize    
    limit = 1
    html_template = '<li><a href="{link}"><img src="{url}" /></a></li>'
    rss_url = "http://api.flickr.com/services/feeds/photos_public.gne?id=97682155@N00&lang=en-us&format=rss_200"
    proxy = nil
    
    doc = open(rss_url, :proxy => proxy) { |f| Hpricot::XML(f) }
    children = doc.search("//item").slice(0 , limit)

    @html = create_html_from_rss_items( children, html_template )
  end

  def create_html_from_rss_items( items, template )
    output = ""
    items.each do | item |
      title = item.at( "title" ).inner_html
      link  = item.at( "link" ).inner_html  
      url   = item.at( "media:thumbnail" ).attributes["url"]
      
      output << replace_in_template_string( template, { :title => title, :link => link, :url => url } )
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

puts "<ol>" + Processor.new.html + "</ol>"