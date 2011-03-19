require 'sinatra/base'
require 'vendor/rack-esi/lib/rack/esi'

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
    
    # Models
    require 'models/book.rb'
    
    # Development
    require "sinatra/reloader" if development?
    configure :development do | config |
      puts "in development"
      register Sinatra::Reloader
      config.also_reload "models/*.rb"
      config.also_reload "layout/views/*.rb"
      config.also_reload "layout/helpers/*.rb"
      config.also_reload "services/*.rb"
      config.also_reload "services.rb"
    end
    
    set :cache_max_age, 31557600
    set :cache_max_age_override, nil
    
    ## This before filter ensures that your pages are only ever served 
    ## once (per deploy) by Sinatra, and then by Varnish after that
    ## Homepage should have a different cache time as otherwise the Pinboard
    ## module would never update.
    ## TODO Investigate ESI fragment caching
    unless development?
      after do
        cache_max_age = settings.cache_max_age
        if settings.cache_max_age_override
          cache_max_age = settings.cache_max_age_override
          settings.cache_max_age_override = nil
        end
        response.headers['Cache-Control'] = "public, max-age=#{cache_max_age}" # 1 year
      end
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
      send_file /\/post\/image\/(.*)/,    'content/posts/images/$1'
      rewrite 	/(\/posts\/(.*))[^\/.]?/, '$1/index.html'
      r302   /\/openid(.*)/, '/'
    end
    
    get '/up' do
      "up"
    end
    
    get '/' do
      settings.cache_max_age_override = 600
      mustache :index
    end
    
    get '/about' do 
      @title    = "About"
      @source   = "content/pages/about.html"
      @page_id  = "cv"
      mustache :page
    end
  
    get '/projects' do 
      @title    = "Projects"
      @source   = "content/pages/projects.html"
      @page_id  = "project"
      mustache :page
    end

    get '/books/:year/:month' do
      month = params[:month]
      year  = params[:year].to_i
      
      # Get book data
      data = YAML::load( File.open( 'content/books/books.yaml' ) )
      @isbns = data["books"][year][month].map { |b| b['isbn'] }
      
      @books = []
      @isbns.each do | isbn | 
        @books.push AndrewNicolaou::Models::Book.find_by_isbn( isbn )
      end.compact!

      DELIM = "&raquo;"
      @title    = "Books read #{DELIM} #{year} #{DELIM} #{month}"

      #@source   = "content/pages/about.html"
      mustache :book
    end
    
    get '/post' do
      @post_list = true
      @title     = "Posts"
      #@list     = AndrewNicolaou::Frontend::Views::Post.new.list(:published => true)
      mustache :post
    end
    
#    get '/post/images/:image' do 
#      @image_file_name = params[:image]
#      
    
    get /(\/post\/(.*))[^\/.]?/ do 
      @post_list = false
      @url = params[:captures].first
      mustache :post
    end    
  end
end