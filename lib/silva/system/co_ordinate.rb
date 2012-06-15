module Silva
  module System
    ##
    # Provides simple validations and accessors for a lat, long, alt co-ordinate system.
    #
    module CoOrdinate
      # Allowed range of latitude
      LAT_RANGE  = (-90..90)
      # Allowed range of longitude
      LONG_RANGE = (-180..180)
      # Allowed range of altitude
      ALT_RANGE  = (-500..4000)

      # Default altitude = 0
      DEFAULT_PARAMS = { :alt => 0 }
      REQUIRED_PARAMS = [:lat, :long]

      attr_reader :lat, :long, :alt

      def inspect
        [lat, long, alt].to_s
      end

      private 

      def validate_lat(lat)
        lat.is_a?(Numeric) && LAT_RANGE.cover?(lat)
      end

      def validate_long(long)
        long.is_a?(Numeric) && LONG_RANGE.cover?(long)
      end

      def validate_alt(alt)
        alt.is_a?(Numeric) && ALT_RANGE.cover?(alt)
      end
    end
  end
end
