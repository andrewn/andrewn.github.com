require 'sinatra/base'
require 'rack/esi'

module AndrewNicolaou
  class Frontend < Sinatra::Base
    use Rack::ShowExceptions
    use Rack::MethodOverride
    use Rack::ESI
    
    use AndrewNicolaou::Services
    
    #use Rack::CommonLogger
    #use Rack::ContentLength
    
    # Templating
    require 'mustache/sinatra'
    register Mustache::Sinatra
    
    require 'rack/bug'
    use Rack::Bug
    require 'rack/bug/panels/mustache_panel'
    use Rack::Bug::MustachePanel
    
    # Views
    require 'layout/views/layout'
    require 'layout/views/post'
    #require 'layout/helpers/helpers'
    set :mustache, {
      :views     => 'layout/views/',
      :templates => 'layout/templates/'
    }
    
    # Development
    require "sinatra/reloader" if development?
    configure :development do | config |
      register Sinatra::Reloader
      config.also_reload "layout/views/*.rb"
      #config.also_reload "layout/helpers/*.rb"
    end
    
    #require 'rack/bug/panels/mustache_panel'
    #use Rack::Bug::MustachePanel
    
    # Enable static files (js, css)
    set :static, true
    set :public, 'content'
    
    # Add /index.html extension to
    # all URLs in /blog
    gem 'rack-rewrite', '~> 1.0.0'
    	 require 'rack/rewrite'
    	 use Rack::Rewrite do
    	 rewrite 	/(\/posts\/(.*))[^\/.]?/, '$1/index.html'
    end
    
    ## This before filter ensures that your pages are only ever served 
    ## once (per deploy) by Sinatra, and then by Varnish after that
    #before do
    #  response.headers['Cache-Control'] = 'public, max-age=31557600' # 1 year
    #end
    
    get '/up' do
      "up"
    end
    
    get '/' do
      mustache :index
    end
    
    get '/about' do 
      @title    = "About"
      @source   = "content/pages/about.html"
      mustache :page
    end
    
    get '/post' do
      @post_list = true
      @title     = "Posts"
      #@list     = AndrewNicolaou::Frontend::Views::Post.new.list(:published => true)
      mustache :post
    end
    
    get /(\/post\/(.*))[^\/.]?/ do 
      @post_list = false
      @url = params[:captures].first
      mustache :post
    end
    
  end
end