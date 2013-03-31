class TestBadData < Test::Unit::TestCase
  def setup
    @data = Silva::Test::DATA_BAD
  end

  def test_wgs84_to_en
    l = Silva::Location.from(:wgs84, @data[:wgs84])
    assert_raise Silva::InvalidParamValueError do
      l.to(:en)
    end
  end

  def test_gridref_to_en
    assert_raise Silva::InvalidParamValueError do
      l = Silva::Location.from(:gridref, @data[:gridref])
    end
  end
end

