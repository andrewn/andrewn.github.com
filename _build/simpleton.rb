require 'rubygems'
require 'sinatra'

# @TODO: Make SSI logic accept single or double quotes
# @TODO: Generalise unsupported patterns to match all SSI directives


# Rack middleware to parse SSIs
# in the response body
class SSIParser  
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
  
  def load_paths( paths )
    all = []
    paths.each do |p|
      path = '/Users/andrew/Projects/Work/andrewn.github.com/_site' + p.first
      c = read_file( path )
      all << {
        :path => p,
        :content => c
      }
    end
    all
  end
end


# Sinatra app
#

use SSIParser

base_path = File.dirname(__FILE__) + "/../_site"
puts base_path

set :public, "_site"

get '/' do
  file_path = base_path + "/index.html"
  file = read_file( file_path )
end

get /(\/[\w]+\/)/ do
  file_path = base_path + params[:captures].to_s + "/index.html"
  read_file( file_path )
end

get '*' do
  file_path = base_path + params[:splat].to_s
  is_dir = File.directory? file_path
  pass unless is_dir
  file_path = file_path + "/index.html"
  read_file(file_path)
end

private 
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