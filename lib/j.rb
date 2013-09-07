require "active_record"
require "yaml"
require "kramdown"

module J
  ROOT = File.dirname(File.realpath(__FILE__))
end

require "j/database"
require "j/entry"
require "j/tag"