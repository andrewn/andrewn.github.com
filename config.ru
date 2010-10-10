#$LOAD_PATH << File.expand_path(File.dirname(File.dirname(__FILE__)))
Dir["vendor/*/lib"].each do
  p path
  |path| $:.unshift path 
end

p $:

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend