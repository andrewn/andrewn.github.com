$LOAD_PATH.unshift File.expand_path(File.dirname(File.dirname(__FILE__))) + '/vendor/rack-esi/lib/rack/'
#Dir["vendor/*/lib"].each { |path| $:.unshift path } 

p $:

require 'esi'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend