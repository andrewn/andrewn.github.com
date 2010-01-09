
# @TODO: Make load path configurable (or fetched from sinatra)
# @TODO: Generalise unsupported patterns to match all SSI directives

# Mixin the ability to read 
# a file from a filesystem 
# path
module FileReader
  def read_file(path)
    puts path
    file = ""
    File.open(path, "r") do |infile|
      while (line = infile.gets)
        file << line
      end
    end
    file
  end
end


# Rack middleware to parse SSIs
# in the response body
class SSIParser  
  include FileReader
  def initialize(app)  
    @app = app  
    
    @ssi_pattern = /<!--#include virtual=['"]([\w\/.-]+)['"]-->/
    @ssi_replace = Proc.new { |v| /<!--#include virtual=['"]#{v}['"]-->/ }
    
    @unsupported_patterns = ["<!--#config errmsg='<!-- error processing directive -->' -->"]
  end  

  def call(env) 
    status, headers, response = @app.call(env)
    response = process( response )
    headers['Content-Length'] = "#{response.length}"
    return [ status, headers, response ]
  end  

  def process( response, body = "" )
    response.each do |s| 
      ssi_paths  = ssi_in_doc(s)
      content    = load_paths(ssi_paths)
      
      content.each do | c |
        s.gsub!( @ssi_replace.call(c[:path]), c[:content] )
      end
      
      # Strip out unsupported SSI commands
      @unsupported_patterns.each do |p|
        s.gsub!(p, "")
      end
      
      body << s 
    end
    return body
  end

  def ssi_in_doc( doc="" ) 
    matches_in_doc = doc.scan(@ssi_pattern)
    return matches_in_doc
  end
  
  def load_paths( relative_paths, path_base=File.dirname(__FILE__) + "/../_site" )    
    all = []
    relative_paths.each do |p|
      path = path_base + p.first
      c = read_file( path )
      all << {
        :path => p,
        :content => c
      }
    end
    all
  end
end


require 'rubygems'
require 'sinatra/base'

# Sinatra app to do basic static 
# file serving but with understanding
# of index files and index redirection
# i.e.  /       -> /index.html [Loads]
#       /about  -> /about/index.html [Loads]
#       /about  -> /about/ [Redirect] [Optional]
#       /about/ -> /about/index.html [Loads]
class Simpleton < Sinatra::Default
  
  include FileReader
  
  use SSIParser

  configure do 
    disable :redirect_to_trailing_slash
    set     :index_file, "index.html"
  end

  enable :redirect_to_trailing_slash
  set :base_path, File.dirname(__FILE__) + "/../_site"
  set :public, File.dirname(__FILE__) + "/../_site"

  get '/' do
    puts 'index'
    file_path = options.base_path + "/#{options.index_file}"
    file = read_file( file_path )
  end

  get /(\/[\w]+\/)\z/ do
    puts 'trailing slash'
    url_path = params[:captures].to_s + "/#{options.index_file}"    
    file_path = options.base_path + url_path
    read_file( file_path )
  end

  get '*' do
    puts "Splat (no trailing slash)"
    
    # The root-relative url path
    url_path = params[:splat].to_s
        
    file_path = options.base_path + url_path
    is_dir = File.directory? file_path
    
    puts "Passing to #{options.public}" unless is_dir
    pass unless is_dir
    
    # Redirect /about -> /about/
    puts "** #{options.redirect_to_trailing_slash}"
    if options.redirect_to_trailing_slash
      redirect url_path + "/"
    else
    # Silently read index 
      file_path = file_path + "/#{options.index_file}"
      read_file(file_path)
    end
  end

end

Simpleton.run!