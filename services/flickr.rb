require 'rubygems'
require 'hpricot'
require 'open-uri'

class Processor

  attr_reader :html
  
  @@num_items       = 1
  @@ignore          = /blank/i
  @@debug           = false
  @@no_title_text   = "(No title)"
  @html
  
  def initialize    
    limit = @@num_items
    html_template = <<-doc
      <li>
        <a href="{link}">
          <img src="{url}" />
        </a>
      </li>
    doc
    rss_url = "http://api.flickr.com/services/feeds/photoset.gne?set=72157622997668729&nsid=97682155@N00&lang=en-us&format=rss_200"
    proxy = nil
    
    doc = open(rss_url, :proxy => proxy) { |f| Hpricot::XML(f) }
    children = doc.search("//item") #.slice(0 , limit)

    @html = create_html_from_rss_items( children, html_template, limit )
  end

  def create_html_from_rss_items( items, template, num_to_return = 1 )
    
    puts "There are #{items.length} photos" if @@debug
    
    ignore = @@ignore
    
    output = []
    items.each do | item |
      title = item.at( "title" ).inner_html
      link  = item.at( "link" ).inner_html  
      url   = item.at( "media:thumbnail" ).attributes["url"]
      tags  = item.at( "media:category").inner_html
      
      puts "Title: #{title}, link: #{link}, url: #{url}, tags: #{tags}" if @@debug
      
      output << replace_in_template_string( template, { :title => title, :link => link, :url => url } ) unless ( ignore.nil? ? false : tags.match( ignore ) )
    end
    return output.slice(0, num_to_return).join(" ")
  end
  
  def replace_in_template_string( str="", hash={} ) 
    
    if hash[:title].nil? or hash[:title].empty?
      # return ""
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

puts "<ol>\n" + Processor.new.html + "\n</ol>"