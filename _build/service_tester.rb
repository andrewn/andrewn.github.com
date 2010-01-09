require 'rubygems'
require 'sinatra'

helpers do
  def styles
    "<style type='text/css'>* { font-family: Helvetica, sans-serif; }</style>"
  end
end

puts "#{__FILE__}"

           # all services in the _bin dir  
services = Dir["#{File.dirname(__FILE__)}/../_bin/*.rb"] 

services.collect! do |item|  
  {
    :name => File.basename( item, '.rb' ),
    :path => item
  }
end

# Get a list of all the services
# in the test rig
get "/" do 
  return styles + "<h1>Services loaded:</h1>" +
          "<ul>" +
          services.map{ |service| "<li><a href='/#{service[:name]}'>#{service[:name]}</a></li>" }.join("") +
          "</ul>"
end

# Run all the services in the 
# test rig
get "/all" do 
  styles + services.map { |s| "<h1>#{s[:name]}</h1>" + s[:proc].call(self) } .join("") + "<hr />"
end

# Create a URL endpoint 
services.each do | service |
  
  # Store the service call as a ruby Proc
  # to be called later
  service[:proc] = Proc.new do |env|
    puts service[:name]
    # Same charset as Apache server
    env.response['Content-Type'] += ";charset=utf-8"
    # Execute the service and return contents to browser
    `ruby #{service[:path]}`
  end
  
  get "/#{service[:name]}" do
    # Call the stored proc and 
    # pass in the current environment
    styles + service[:proc].call(self)
  end
  
  puts "Loaded #{service[:name]}"
  
end
