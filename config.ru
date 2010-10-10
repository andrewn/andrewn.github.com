
Dir.glob(File.dirname(__FILE__) + "/vendor/*").each do |path|
 gem_name = File.basename(path.gsub(/-[\d\.]+$/, ''))
 $LOAD_PATH << path + "/lib/"
end

p $LOAD_PATH

require 'rack/esi'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend