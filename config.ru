
Dir.glob(File.dirname(__FILE__) + "/vendor/*").each do |path|
 gem_name = File.basename(path.gsub(/-[\d\.]+$/, ''))
p path
 $LOAD_PATH << path + "/lib/"
 require gem_name
end

p $LOAD_PATH

require 'rack/esi'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend