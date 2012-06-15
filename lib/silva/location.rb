module Silva
  ##
  # A spoonful of syntactic sugar for creating location systems from the relevant parameters:
  #
  # loc = Silva::Location.from(:en, :easting => 651409, :northing => 31377).to(:wgs84)
  # lat = loc.lat, long = loc.long
  #
  module Location
    ##
    # Create a location system from the given parameters.
    # 
    # @param [Symbol] system_name The name of the system -- at present, :wgs84, :en, :osgb36 or :gridref.
    # @param [Hash] options Parameters relevant to the system (see individual systems for details).
    # @return [Silva::System] A new location system.
    def self.from(system_name, options)
      Silva::System.create(system_name, options)
    end
  end
end
