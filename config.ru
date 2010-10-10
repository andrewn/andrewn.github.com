
Dir.glob(File.dirname(__FILE__) + "/vendor/*").each do |path|
 gem_name = File.basename(path.gsub(/-[\d\.]+$/, ''))
 $LOAD_PATH << path + "/lib/rack"
end

p $LOAD_PATH

require 'esi'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend