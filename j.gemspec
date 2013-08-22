# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "j"
  s.version = File.read("version.txt")
  s.licenses = "CC-BY-SA"
  
  s.summary = "A gem to record journal thoughts."
  s.description = "Records journally things in an sqlite database. Based loosely off the [Bullet Journal](http://www.bulletjournal.com/)."
  
  s.author = "Jan-Yves Ruzicka"
  s.email = "jan@1klb.com"
  s.homepage = "https://www.1klb.com"
  
  s.files = File.read("Manifest").split("\n").select{ |l| !l.start_with?("#") && l != ""}
  s.require_paths << "lib"
  s.bindir = "bin"
  s.executables << "j"
  s.extra_rdoc_files = ["README.md"]

  # Add runtime dependencies here
  s.add_runtime_dependency "commander", "~> 4.1.4"
  s.add_runtime_dependency "activerecord", "~> 4.0.0"
  s.add_runtime_dependency "sqlite3", "~> 1.3.8"
end
