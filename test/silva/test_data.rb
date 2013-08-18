module Silva
  module Test
    DATA = [{
              # from os worked examples
              :wgs84 => { :lat => 52.658007833, :long => 1.716073973, :alt => 180.05 },
              :osgb36 => { :lat => 52.65757, :long => 1.717922, :alt => 180.05 },
              :en => { :easting => 651409.903, :northing => 313177.270 },
              :gridref => "TG51411318"
            },
            {
              # greenwich
              :wgs84 => { :lat => 51.478017, :long => -0.001619 },
              :osgb36 => { :lat => 51.477501, :long => 0, :alt => 0 },
              :en => { :easting => 538874, :northing => 177344 },
              :gridref => "TQ38877734"
            }]

    DATA_BAD = {
      :wgs84 => { :lat => 30, :long => 10 },
      :en => { :easting => 50, :northing => 220000 },
      :gridref => {:gridref => "TC00502200" }
    }

    LAT_DELTA = 5e-5
    LONG_DELTA = 2.5e-5
    EN_DELTA = 10
    COORD_FROM_GRIDREF_DELTA = 1e-4
  end
end
