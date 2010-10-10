
Dir.glob(File.dirname(__FILE__) + "/vendor/*").each do |path|
 gem_name = File.basename(path.gsub(/-[\d\.]+$/, ''))
 $LOAD_PATH.unshift path + "/lib/rack"
end

p $LOAD_PATH

require 'esi.rb'

#require 'services'
#require 'frontend'
#
#run AndrewNicolaou::Frontend