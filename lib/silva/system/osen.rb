module Silva
  module System
    module OsEn
      ##
      # Provides simple validations for OS easting/northing systems.
      #
      
      # Allowed range of eastings
      EASTING_RANGE = (0..700000)
      # Allowed range of northings
      NORTHING_RANGE = (0..1300000)

      REQUIRED_PARAMS = [:easting, :northing]

      attr_reader :easting, :northing

      private

      def validate_easting(e)
        e.is_a?(Numeric) && EASTING_RANGE.cover?(e)
      end

      def validate_northing(n)
        n.is_a?(Numeric) && NORTHING_RANGE.cover?(n)
      end
    end
  end
end
