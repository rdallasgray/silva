class TestLocation < Test::Unit::TestCase
  def test_invalid_system_raises_error
    assert_raise Silva::InvalidSystemError do 
      l = Silva::Location.from(:invalid, nil)
    end
  end

  def test_invalid_param_raises_error
    assert_raise Silva::InvalidParamError do
      l = Silva::Location.from(:wgs84, :lat => 0, :long => 0, :altitude => 0)
    end
  end

  def test_invalid_value_raises_error
    assert_raise Silva::InvalidParamValueError do
      l = Silva::Location.from(:wgs84, :lat => "five", :long => 0, :alt => 0)
    end
  end

  def test_co_ordinate_system_out_of_range_param_raises_error
    assert_raise Silva::InvalidParamValueError do
      l = Silva::Location.from(:wgs84, :lat => 185, :long => 0, :altitude => 0)
    end
  end

  def test_co_ordinates_set_correctly
    Silva::Test::DATA.each do |data|
      l = Silva::Location.from(:wgs84, data[:wgs84]).to(:wgs84)
      assert(l.lat == data[:wgs84][:lat] && l.long == data[:wgs84][:long] && l.alt == data[:wgs84][:alt], \
             "Failed assigning co-ords to System::Wgs84")
    end
  end
end
