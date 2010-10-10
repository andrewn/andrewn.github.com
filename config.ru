$LOAD_PATH.unshift File.expand_path(File.dirname(File.dirname(__FILE__)))
#Dir["vendor/*/lib"].each { |path| $:.unshift path } 

p $:

require 'vendor/rack-esi/lib/rack/esi.rb'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend