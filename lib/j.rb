require "active_record"
require "yaml"
require "kramdown"

module J
  ROOT = File.dirname(File.realpath(__FILE__))
end

%w(database entry tag image).each{ |f| require "j/#{f}" }