
require "rubygems"
Gem.clear_paths
gem_paths = [
  File.expand_path("#{File.dirname(__FILE__)}/../vendor/gems"),
  Gem.default_dir,
]
gem_paths << APPLE_GEM_HOME if defined?(APPLE_GEM_HOME)
Gem.send :set_paths, gem_paths.join(":")

require 'rack/esi'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend