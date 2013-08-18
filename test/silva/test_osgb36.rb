require_relative '../test_helper'

class TestOsgb36 < Test::Unit::TestCase
  def test_osgb36_to_en
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:osgb36, data[:osgb36]).to(:en)
      assert_in_delta data[:en][:easting], l.easting, Silva::Test::EN_DELTA
      assert_in_delta data[:en][:northing], l.northing, Silva::Test::EN_DELTA
    end
  end

  def test_osgb36_to_wgs84
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:osgb36, data[:osgb36]).to(:wgs84)
      assert_in_delta data[:wgs84][:lat], l.lat, Silva::Test::LAT_DELTA
      assert_in_delta data[:wgs84][:long], l.long, Silva::Test::LONG_DELTA
    end
  end

  def test_osgb36_to_gridref
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:osgb36, data[:osgb36]).to(:gridref, :digits => 8)
      # Final digit too sensitive in os examples
      assert_equal data[:gridref][0..-2], l.gridref[0..-2]
    end
  end
end
