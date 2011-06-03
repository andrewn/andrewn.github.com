#ENV['RACK_ENV'] = "development"

require 'services'
require 'app/frontend'

AndrewNicolaou::Frontend.set :app_version, "2.5"
run AndrewNicolaou::Frontend