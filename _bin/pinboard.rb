require 'rubygems'
require 'hpricot'
require 'open-uri'

class PinboardProcessor

  @@no_title_text = "(No title)"
  
  def initialize    
    limit = 5
    html_template = '<a href="{link}">{title}</a>'
    rss_url = "http://feeds.pinboard.in/rss/u:andrewn"
    proxy = nil
    
    doc = open(rss_url, :proxy => proxy) { |f| Hpricot::XML(f) }
    children = doc.search("//item").slice(0 , limit)
    
    html = create_html_from_rss_items( children, html_template )
  end

  def create_html_from_rss_items( items, template )
    items.each do | item |
      title = item.at( "title" ).inner_html
      url   = item.at( "link" ).inner_html  
      puts replace_in_template_string( template, { :title => title, :link => url } )
    end
  end
  
  def replace_in_template_string( str="", hash={} ) 
    
    if hash[:title].nil? or hash[:title].empty?
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

PinboardProcessor.new