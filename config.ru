
Dir.glob(File.dirname(__FILE__) + "/vendor/*").each do |path|
 gem_name = File.basename(path.gsub(/-[\d\.]+$/, ''))
 $LOAD_PATH << path + "/lib/"
 require gem_name
end

require 'rack/esi'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend