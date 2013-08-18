require 'silva/system/base'
require 'silva/system/co_ordinate'
require 'silva/transform'

module Silva
  module System
    ##
    # Location system representing OSGB36 co-ordinates.
    #
    class Osgb36 < Base
      include CoOrdinate

      private

      def to_en(options = nil)
        Silva::Transform.osgb36_to_en(self)
      end

      def to_gridref(options = nil)
        to_en.to(:gridref, options)
      end

      def to_wgs84(options = nil)
        Silva::Transform.osgb36_to_wgs84(self)
      end
    end
  end
end
