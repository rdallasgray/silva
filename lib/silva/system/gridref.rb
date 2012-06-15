module Silva
  module System
    ##
    # Location system representing Ordnance Survey Standard Grid References.
    # 
    # Can be created given the options :easting => e, :northing => n or :gridref => g
    #
    class Gridref < Base
      include OsEn
      # :digits can be 6, 8 or 10
      DEFAULT_PARAMS = { :digits => 8 }
      # UK two-letter prefixes
      OSGB_PREFIXES = ["SV", "SW", "SX", "SY", "SZ", "TV", "TW",
                       "SQ", "SR", "SS", "ST", "SU", "TQ", "TR",
                       "SL", "SM", "SN", "SO", "SP", "TL", "TM",
                       "SF", "SG", "SH", "SJ", "SK", "TF", "TG",
                       "SA", "SB", "SC", "SD", "SE", "TA", "TB",
                       "NV", "NW", "NX", "NY", "NZ", "OV", "OW",
                       "NQ", "NR", "NS", "NT", "NU", "OQ", "OR",
                       "NL", "NM", "NN", "NO", "NP", "OL", "OM",
                       "NF", "NG", "NH", "NJ", "NK", "OF", "OG",
                       "NA", "NB", "NC", "ND", "NE", "OA", "OB",
                       "HV", "HW", "HX", "HY", "HZ", "JV", "JW",
                       "HQ", "HR", "HS", "HT", "HU", "JQ", "JR",
                       "HL", "HM", "HN", "HO", "HP", "JL", "JM"]
      # Width of the UK grid
      OSGB_GRID_WIDTH = 7
      # Height of the UK grid
      OSGB_GRID_SCALE = 100000

      attr_reader :gridref

      ##
      # Lazily create the gridref from given eastings and northings, or just return it if already set.
      #
      # @return [String] A standard Ordnance Survey grid reference with the given number of digits.
      #
      def gridref
        unless @gridref
          e100k = (@easting / 100000).floor
          n100k = (@northing / 100000).floor
          
          index = n100k * OSGB_GRID_WIDTH + e100k
          prefix = OSGB_PREFIXES[index]
          
          e = ((@easting % OSGB_GRID_SCALE) / (10**(5 - @digits / 2))).round
          n = ((@northing % OSGB_GRID_SCALE) / (10**(5 - @digits / 2))).round
          
          @gridref = prefix + e.to_s.rjust(@digits / 2) + n.to_s.rjust(@digits / 2)
        end

        @gridref
      end

      def to_s
        gridref
      end


      private

      def to_wgs84(options = nil)
        Silva::Transform.osgb36_to_wgs84(to_osgb36)
      end

      def to_osgb36(options = nil)
        Silva::Transform.en_to_osgb36(to_en)
      end

      def to_en(options = nil)
        e100k, n100k = prefix_to_en
        gridref.delete!(' ')
        en = gridref[2..-1]
        e = en[0, (en.length / 2)].ljust(5, '5').to_i + e100k
        n = en[(en.length / 2)..-1].ljust(5, '5').to_i + n100k

        System.create(:en, :easting => e, :northing => n )
      end

      def get_prefix
        gridref[0..1]
      end

      def prefix_to_en
        index = OSGB_PREFIXES.index(get_prefix)
        e = index % OSGB_GRID_WIDTH
        n = index / OSGB_GRID_WIDTH

        [e * OSGB_GRID_SCALE, n * OSGB_GRID_SCALE]
      end

      def validate_digits(digits)
        [6, 8, 10].include?(digits)
      end

      def validate_gridref(gridref)
        gridref.match /[HJNOST][A-Z][0-9]{3,5}[0-9]{3,5}/
      end

      def params_satisfied?(options)
        super or options.include?(:gridref)
      end
    end
  end
end
