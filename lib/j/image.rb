require "fileutils"

class J::Image < ActiveRecord::Base
  include FileUtils
  # Methods from SQL: name

  # This is where images get stored
  IMAGE_ROOT = File.join(ENV['HOME'], ".j/images/")
  mkdir_p IMAGE_ROOT

  # Generate the full path of the image
  def path
    @path ||= File.join(IMAGE_ROOT, name)
  end

  # When we change the name of the image, also move it
  def name= new_name
    mv name, new_name
    super new_name
  end

  # Create one of these from a file on disk
  def self.upload(source)
    base = timestamp(File.basename(source))
    cp source, timestamp_base
    return new(name: timestamp_base)
  end

  # Generate a timestamped file name
  def self.timestamp(name)
    Time.now.utc.strftime("%Y%m%d-%H%M%S-")+name
  end 
end