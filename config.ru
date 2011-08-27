#ENV['RACK_ENV'] = "development"

require 'services'
require 'app/frontend'

AndrewNicolaou::Frontend.set :app_version, (ENV['COMMIT_HASH'].nil? ? "dev" : ENV['COMMIT_HASH'])
run AndrewNicolaou::Frontend