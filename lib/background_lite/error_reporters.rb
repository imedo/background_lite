Dir["#{File.dirname(__FILE__)}/error_reporters/*.rb"].sort.each do |path|
  require "background_lite/error_reporters/#{File.basename(path, '.rb')}"
end
