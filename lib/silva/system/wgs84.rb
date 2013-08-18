require 'silva/system/base'
require 'silva/system/co_ordinate'
require 'silva/transform'

module Silva
  module System
    ##
    # Location system representing WGS84 co-ordinates.
    #
    class Wgs84 < Base
      include CoOrdinate

      private

      def to_osgb36(options = nil)
        Silva::Transform.wgs84_to_osgb36(self)
      end

      def to_en(options = nil)
        to_osgb36.to(:en)
      end

      def to_gridref(options = nil)
        to_en.to(:gridref, options)
      end
    end
  end
end
