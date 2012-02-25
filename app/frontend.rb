require 'sinatra/base'

#require 'vendor/rack-esi/lib/rack/esi'

#require 'esi_for_rack'
#require 'rack-esi'

module AndrewNicolaou
  class Frontend < Sinatra::Base
    #use EsiForRack
    #use Rack::ESI
    
    use Rack::ShowExceptions
    use Rack::MethodOverride
    
    use AndrewNicolaou::Services
    
    #use Rack::CommonLogger
    #use Rack::ContentLength
    
    # Templating
    require 'mustache/sinatra'
    register Mustache::Sinatra
    require 'layout/views/layout'
    set :mustache, {
      :views     => 'layout/views',
      :templates => 'layout/templates/'
    }
        
    require 'rack/bug'
    use Rack::Bug
    require 'rack/bug/panels/mustache_panel'
    use Rack::Bug::MustachePanel
    
    # Models
    require 'models/book.rb'
    require 'models/file_store.rb'
    require 'models/project.rb'
    require 'models/post.rb'
    
    # Development
    require "sinatra/reloader" if development?
    configure :development do | config |
      puts "in development"
      #enable :logging
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
    unless development?
      after do
        cache_max_age = settings.cache_max_age
        if settings.cache_max_age_override
          cache_max_age = settings.cache_max_age_override
          settings.cache_max_age_override = nil
        end

        if ENV['DISABLE_CACHING'] == "true"
          puts "Skipping caching"
        else
          response.headers['Cache-Control'] = "public, max-age=#{cache_max_age}" # 1 year
        end
      end
    end

    # Ensure that HTML, CSS and JS are all set
    # to charset utf-8
    # http://geminstallthat.wordpress.com/2009/04/22/sinatra-utf-8-content-type-before-filter/
    CONTENT_TYPES = {:html => 'text/html', :css => 'text/css', :js  => 'application/javascript'}
    before do
      #request_uri = case request.env['REQUEST_URI']
      #  when /\.css$/ : :css
      #  when /\.js$/  : :js
      #  else          :html
      #end
      #content_type CONTENT_TYPES[request_uri], :charset => 'UTF-8'

      # set domain of incoming request
      @host = "#{request.scheme}://#{request.host_with_port}"

      @app_version = settings.app_version
      @cachebuster = "v#{@app_version}"
    end

    
    #require 'rack/bug/panels/mustache_panel'
    #use Rack::Bug::MustachePanel
    
    # Enable static files (js, css)
    set :static, true
    set :public, 'content'
    
    # Add /index.html extension to
    # all URLs in /blog
    #gem 'rack-rewrite', '~> 1.0.0'
    #require 'rack/rewrite'
    #use Rack::Rewrite do
    #  send_file /\/post\/image\/(.*)/,    'content/posts/images/$1'
    #  rewrite 	/(\/posts\/(.*))[^\/.]?/, '$1/index.html'
    #  r302   /\/openid(.*)/, '/'
    #end

    ##
    ## ROUTES
    ##
    
    get '/up' do
      "up (v#{@app_version})"
    end
    
    get '/' do
      #settings.cache_max_age_override = 600
      @projects_list = AndrewNicolaou::Models::Project.find_all
      @posts_list    = AndrewNicolaou::Models::Post.find_all
      mustache :index
    end

    get '/cv' do
      @page_id  = "cv"
      mustache :cv
    end

    get '/code' do
      @page_id  = "code"
      mustache :code
    end

    get '/cv/extended' do
      @extended = true
      @page_id  = "cv"
      mustache :cv
    end
  
    # TODO: [R 301] -> /projects/all
    get '/all' do
      @page_id = "all"
      @show_intro    = false
      @project_scope = "All"
      #settings.cache_max_age_override = 600
      @projects_list = AndrewNicolaou::Models::Project.find_all(:all).find_all do |project|
        project['scope'] != 'deprecated'
      end
      mustache :index
    end

    get '/posts' do
      @page_id = "posts"
      @show_intro = false
      @post_list = AndrewNicolaou::Models::Post.find_all
      puts "Found #{@post_list.length} posts"
      p @post_list
      mustache :post_list
    end

    get '/posts/:slug' do |slug|
      @page_id = "page-post"
      @post = AndrewNicolaou::Models::Post.find_by_slug(slug)
      halt 404 unless @post
      mustache :post
    end

    require 'httpclient'
    get '/someday' do
      client = HTTPClient.new
      list_url = "https://raw.github.com/gist/df5d50c14dffd6928001/d8a998998313a1e342f93236f351380bf9a8c2df/someday.md"
      resp = client.get(list_url)
      @post = {
        'title'   => "Someday",
        'content' => BlueCloth.new( resp.content ).to_html
      }
      mustache :post
    end

    get '/assets/css/base.css' do
      @app_version = 'v' + @app_version

      content_type :css
      mustache :css_base, :layout => false
    end

    #get '/about' do 
    #  @title    = "About"
    #  @source   = "content/pages/about.html"
    #  @page_id  = "cv"
    #  mustache :page
    #end
  
    #get '/projects' do 
    #  @title    = "Projects"
    #  @source   = "content/pages/projects.html"
    #  @page_id  = "project"
    #  mustache :page
    #end

    get '/books' do 
       # Get book data
      data = YAML::load( File.open( 'content/books/books.yaml' ) )
      @book_data = data["books"]
 
      @books = []
      @book_data.each do | b | 
        book = AndrewNicolaou::Models::Book.find_by_isbn( b['isbn'] )
        book[:cover?]     = book[:cover].empty? ? nil : book[:cover]
        book[:date]       = b['date'] + 'T00:00'
        book[:human_date] = Date.parse(b['date']).strftime("%B %Y")
        @books.push book
      end.compact!
      
      @title= "Books read"
      
      mustache :book     
    end

    #get '/books/:year/:month' do
    #  month = params[:month]
    #  year  = params[:year].to_i
    #  
    #  # Get book data
    #  data = YAML::load( File.open( 'content/books/books.yaml' ) )
    #  @isbns = data["books"][year][month].map { |b| b['isbn'] }
    #  
    #  @books = []
    #  @isbns.each do | isbn | 
    #    @books.push AndrewNicolaou::Models::Book.find_by_isbn( isbn )
    #  end.compact!
    #  
    #  DELIM = "&raquo;"
    #  @title    = "Books read #{DELIM} #{year} #{DELIM} #{month}"
    #  
    #  #@source   = "content/pages/about.html"
    #  mustache :book
    #end
    
    #get '/post' do
    #  @post_list = true
    #  @title     = "Posts"
    #  #@list     = AndrewNicolaou::Frontend::Views::Post.new.list(:published => true)
    #  mustache :post
    #end   
    
    #get /(\/post\/(.*))[^\/.]?/ do 
    #  @post_list = false
    #  @url = params[:captures].first
    #  mustache :post
    #end    
  end
end