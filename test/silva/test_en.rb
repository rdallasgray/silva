require_relative '../test_helper'

class TestEn < Test::Unit::TestCase

  def test_en_to_wgs84
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:en, data[:en]).to(:wgs84)
      assert_in_delta data[:wgs84][:lat], l.lat, Silva::Test::LAT_DELTA
      assert_in_delta data[:wgs84][:long], l.long, Silva::Test::LONG_DELTA
    end
  end

  def test_en_to_osgb36
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:en, data[:en]).to(:osgb36)
      assert_in_delta data[:osgb36][:lat], l.lat, Silva::Test::LAT_DELTA
      assert_in_delta data[:osgb36][:long], l.long, Silva::Test::LONG_DELTA
    end
  end

  def test_en_to_gridref
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:en, data[:en]).to(:gridref, :digits => 8)
      assert_equal data[:gridref], l.gridref
    end
  end
end
