Dir["#{File.dirname(__FILE__)}/handlers/*.rb"].sort.each do |path|
  require "background_lite/handlers/#{File.basename(path, '.rb')}"
end
