require 'silva/system/base'
require 'silva/system/osen'
require 'silva/transform'

module Silva
  module System
    ##
    # Location system representing Ordnance Survey OSGB36 eastings and northings.
    #
    class En < Base
      include OsEn

      def to_s
        [easting, northing].to_s
      end

      private

      def to_osgb36(options = nil)
        Silva::Transform.en_to_osgb36(self)
      end

      def to_wgs84(options = nil)
        Silva::Transform.osgb36_to_wgs84(to_osgb36)
      end

      def to_gridref(options = nil)
        options ||= {}
        options = options.merge({ :easting => easting, :northing => northing })
        System.create(:gridref, options)
      end
    end
  end
end
