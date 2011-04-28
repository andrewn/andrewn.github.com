require 'sinatra/base'

module AndrewNicolaou
  class Services < Sinatra::Base
    use Rack::ShowExceptions
    use Rack::MethodOverride
    #use Rack::CommonLogger
    #use Rack::ContentLength
    
    SERVICE = '/service'
    
    #
    ## This before filter ensures that your pages are only ever served 
    ## once (per deploy) by Sinatra, and then by Varnish after that
    #before do
    #  response.headers['Cache-Control'] = 'public, max-age=31557600' # 1 year
    #end
    
    get "#{SERVICE}/up" do
      "UP"
    end
        
    # Takes the service name e.g. 'bob':
    #   1. require( _bin/bob )
    #   2. BobProcess.new.html
    #
    get "#{SERVICE}/:service" do |service|
      require "services/#{service}" 
      cache_max_age = 60 * 10
      response.headers['Cache-Control'] = "public, max-age=#{cache_max_age}"
      Kernel.const_get( service.capitalize + 'Processor' ).new.html(params)
    end
    
  end
end