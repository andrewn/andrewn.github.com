
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
    
    @ssi_pattern   = /(<!--#([\w]*) (.*)-->)/
    @ssi_supported = {
      :include => lambda do | body, whole_directive, directive, params |
        param_pattern = /(virtual)=['"]([\w\/.-]+)['"]/
        matches = params.match( param_pattern )
        inc_type = matches[1]
        rel_path = matches[2]
        
        file_content = load_path( rel_path )
        body.sub!( whole_directive, file_content )
      end
    }

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
      
      ssi_paths.each do | ssi |
        whole_directive = ssi[0]
        directive       = ssi[1]
        parameters      = ssi[2]
        
        puts "#{whole_directive} #{directive}: #{parameters}"
        
        if !@ssi_supported[ directive.to_sym ].nil?
          @ssi_supported[ directive.to_sym ].call( s, whole_directive, directive, parameters )
        else
          s.gsub!( whole_directive, "" )
        end
      end
      
      body << s 
    end
    return body
  end

  def ssi_in_doc( doc="" ) 
    matches_in_doc = doc.scan(@ssi_pattern)
    return matches_in_doc
  end
  
  def load_path( relative_path, path_base=File.dirname(__FILE__) + "/../_site" )
    path = path_base + relative_path
    c = read_file( path )
  end

end


# Add current dir to load path
$LOAD_PATH << File.dirname( __FILE__ )
require 'rubygems'
require 'sinatra/base'
require 'firebug_logger.rb'

# Sinatra app to do basic static 
# file serving but with understanding
# of index files and index redirection
# i.e.  /       -> /index.html [Loads]
#       /about  -> /about/index.html [Loads]
#       /about  -> /about/ [Redirect] [Optional]
#       /about/ -> /about/index.html [Loads]
class Simpleton < Sinatra::Base
  
  include FileReader
  
  use SSIParser
  use FirebugLogger

  def log(msg="", level=:info)
    puts msg
    env['firebug.logs'] = [] if env['firebug.logs'].nil?
    env['firebug.logs'] << [level, msg]
  end
    
  configure do 
    disable :redirect_to_trailing_slash
    set     :index_file, "index.html"
    
    # Everything is off in Sinatra::Base so 
    # copied these defaults from Sinatra::Application
    set :raise_errors, Proc.new { test? }
    set :show_exceptions, Proc.new { development? }
    set :dump_errors, true
    set :logging, Proc.new { ! test? }
    set :static, true
  end

  enable :redirect_to_trailing_slash
  set :base_path, File.dirname(__FILE__) + "/../_site"
  set :public, File.dirname(__FILE__) + "/../_site"
  
  # Matches the root
  # Serves /:index_file
  get '/' do
    log 'index'
    file_path = options.base_path + "/#{options.index_file}"
    file = read_file( file_path )
  end

  # Matches anything ending in a '/'
  # Serves /.../:index_file
  get /(\/[\w]+\/)\z/ do
    log 'trailing slash'
    url_path = params[:captures].to_s + "/#{options.index_file}"    
    file_path = options.base_path + url_path
    read_file( file_path )
  end

  # Matches anything else
  # If the URL matches a directory on 
  # the file system then either:
  #   - Serves /.../index.html
  #   - Redirects to /.../
  # Otherwise, assume a file and 
  # pass through to load static
  # file.
  get '*' do
    log "Splat (no trailing slash)"
    
    # The root-relative url path
    url_path = params[:splat].to_s
        
    file_path = options.base_path + url_path
    is_dir = File.directory? file_path
    
    log "Passing to #{options.public}" unless is_dir
    pass unless is_dir
    
    # Redirect /about -> /about/
    log "** #{options.redirect_to_trailing_slash}"
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