#$LOAD_PATH << File.expand_path(File.dirname(File.dirname(__FILE__)))
Dir["vendor/*/lib"].each { |path| $:.unshift path } 

p $:

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend