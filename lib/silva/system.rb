require 'silva/system/en'
require 'silva/system/osgb36'
require 'silva/system/gridref'
require 'silva/system/wgs84'

module Silva
  ##
  # A location system -- :wgs84, :osgb36, :en or :gridref.
  module System
    ##
    # A factory method to simplify and moderate creation of location systems.
    # @param [Symbol] system_name The name of the system to be created.
    # @param [Hash] options Parameters relevant to the given system.
    # @return [Silva::System] A valid location system.
    # @raises Silva::InvalidSystemError If the given system can't be created.
    def self.create(system_name, options)
      system = Silva::System.const_get(system_name.to_s.capitalize)
      system.new(options)
    rescue NameError
      raise Silva::InvalidSystemError, "Can't create system: #{system_name}"
    end
  end
end
