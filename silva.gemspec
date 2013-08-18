# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'silva/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Robert Dallas Gray"]
  gem.email         = ["mail@robertdallasgray.com"]
  gem.summary         = "Convert between the GPS (WGS84) location standard and UK Ordnance Survey standards."
  gem.description     = "Silva converts location data to and from WGS84, OSGB36, eastings/northings and standard OS grid references."
  gem.homepage        = "http://github.com/rdallasgray/silva"
  gem.license         = "FreeBSD"
  gem.required_ruby_version      = ">= 1.9"
  gem.add_development_dependency "test-unit"

  gem.files         = Dir.glob("lib/**/*") + %w{LICENSE.txt README.md Rakefile}
  gem.test_files    = Dir.glob("test/**/*")
  gem.name          = "silva"
  gem.require_paths = ["lib"]
  gem.version       = Silva::VERSION
end
