# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'silva/version'

Gem::Specification.new do |spec|
  spec.name          = 'silva'
  spec.version       = Silva::VERSION
  spec.authors       = ['Robert Dallas Gray']
  spec.email         = ['mail@robertdallasgray.com']
  spec.description   = %q{Convert between the GPS (WGS84) location standard and UK Ordnance Survey standards}
  spec.summary       = %q{Silva converts location data to and from WGS84, OSGB36, eastings/northings and standard OS grid references.}
  spec.homepage      = 'https://github.com/rdallasgray/silva.git'
  spec.license       = 'FreeBSD'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(/test\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'pry'
end
