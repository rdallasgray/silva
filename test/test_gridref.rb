class TestGridref < Test::Unit::TestCase
  def test_gridref_no_digits
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:en, data[:en]).to(:gridref)
      assert_equal(data[:gridref], l.to_s)
    end
  end
  
  def test_gridref_to_en
    Silva::Test::DATA.each do |data|
      options = { :gridref => data[:gridref], :digits => 8 }
      l = Silva::Location.from(:gridref, options).to(:en)
      assert_in_delta data[:en][:easting], l.easting, Silva::Test::EN_DELTA
      assert_in_delta data[:en][:northing], l.northing, Silva::Test::EN_DELTA
    end
  end

  def test_gridref_to_osgb36
    Silva::Test::DATA.each do |data|
      options = { :gridref => data[:gridref], :digits => 8 }
      l = Silva::Location.from(:gridref, options).to(:osgb36)
      assert_in_delta data[:osgb36][:lat], l.lat, Silva::Test::COORD_FROM_GRIDREF_DELTA
      assert_in_delta data[:osgb36][:long], l.long, Silva::Test::COORD_FROM_GRIDREF_DELTA
    end
  end

  def test_gridref_to_wgs84
    Silva::Test::DATA.each do |data|
      options = { :gridref => data[:gridref], :digits => 8 }
      l = Silva::Location.from(:gridref, options).to(:wgs84)
      assert_in_delta data[:wgs84][:lat], l.lat, Silva::Test::COORD_FROM_GRIDREF_DELTA
      assert_in_delta data[:wgs84][:long], l.long, Silva::Test::COORD_FROM_GRIDREF_DELTA
    end
  end
end
