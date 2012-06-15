# -*- encoding: utf-8 -*-
require File.expand_path('../lib/silva/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robert Dallas Gray"]
  gem.email         = ["mail@robertdallasgray.com"]
  gem.summary         = "Convert between the GPS (WGS84) location standard and UK Ordnance Survey standards."
  gem.description     = "Silva converts location data to and from WGS84, OSGB36, eastings/northings and standard OS grid references."
  gem.homepage        = "http://github.com/rdallasgray/silva"
  gem.license         = "FreeBSD"
  gem.required_ruby_version      = ">= 1.9"
  gem.add_development_dependency "test/unit"


  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "silva"
  gem.require_paths = ["lib"]
  gem.version       = Silva::VERSION
end
