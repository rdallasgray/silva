require_relative '../test_helper'

class TestWgs84 < Test::Unit::TestCase
  def test_wgs84_to_en
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:wgs84, data[:wgs84]).to(:en)
      assert_in_delta data[:en][:easting], l.easting, Silva::Test::EN_DELTA
      assert_in_delta data[:en][:northing], l.northing, Silva::Test::EN_DELTA
    end
  end

  def test_wgs84_to_osgb36
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:wgs84, data[:wgs84]).to(:osgb36)
      assert_in_delta data[:osgb36][:lat], l.lat, Silva::Test::LAT_DELTA
      assert_in_delta data[:osgb36][:long], l.long, Silva::Test::LONG_DELTA
    end
  end

  def test_wgs84_to_gridref
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:wgs84, data[:wgs84]).to(:gridref, :digits => 8)
      assert_equal data[:gridref], l.gridref
    end
  end
end
