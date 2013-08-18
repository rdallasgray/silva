# Silva makes it simple to convert WGS84 (GPS) location data to and from the UK
# Ordnance Survey OSGB36 formats (grid references, eastings/northings, and longitude/latitude).
#
# Silva was inspired by the work of Chris Veness and Harry Wood:
# http://www.movable-type.co.uk/scripts/latlong-convert-coords.html
# http://www.harrywood.co.uk/blog/2010/06/29/ruby-code-for-converting-to-uk-ordnance-survey-coordinate-systems-from-wgs84/
#
# Portions of Harry's code remain, especially in Silva::Transform::helmert_transform,
# but algorithms have been clarified so as to be easily comparable with those given by
# Ordnance Survey.
#
# Usage:
# location = Silva::Location.from(:wgs84, data[:wgs84]).to(:gridref, :digits => 8)
#
# Author::    Robert Dallas Gray
# Copyright:: Copyright (c) 2012 Robert Dallas Gray
# Requires::  Ruby 1.9
# License::   Provided under the FreeBSD License (http://www.freebsd.org/copyright/freebsd-license.html)

require 'silva/version'
require 'silva/location'
require 'silva/system'

module Silva
  ##
  # Indicates that an invalid system name has been passed.
  class InvalidSystemError < StandardError; end
  ##
  # Indicates that an invalid transform has been attempted.
  class InvalidTransformError < StandardError; end
  ##
  # Indicates that an invalid parameter has been passed.
  class InvalidParamError < StandardError; end
  ##
  # Indicates that an invalid parameter value has been passed.
  class InvalidParamValueError < StandardError; end
  ##
  # Indicates that an insufficient parameters have been passed.
  class InsufficientParamsError < StandardError; end
end
