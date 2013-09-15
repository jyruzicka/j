require "fileutils"

class J::Image < ActiveRecord::Base
  include FileUtils
  # Methods from SQL: name

  # This is where images get stored
  IMAGE_ROOT = File.join(ENV['HOME'], ".j/images/")
  FileUtils.mkdir_p IMAGE_ROOT

  # Generate the full path of the image
  def path
    @path ||= File.join(IMAGE_ROOT, name)
  end

  # When we change the name of the image, also move it
  def name= new_name
    mv path, J::Image.pathify(new_name) if name
    super new_name
  end

  # Create one of these from a file on disk
  def self.upload(source)
    base = timestamp(File.basename(source))
    base_path = pathify(base)
    FileUtils.cp source, base_path
    return new(name: base)
  end

  # Generate a timestamped file name
  def self.timestamp(name)
    Time.now.utc.strftime("%Y%m%d-%H%M%S-")+name
  end

  # Assuming a file base, work out a path
  def self.pathify(file)
    File.join(IMAGE_ROOT, file)
  end

  # String representation
  def to_s
    name
  end
end