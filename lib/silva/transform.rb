module Silva
  ##
  # Encapsulates the hairy maths required to perform the various transforms.
  # Checked against documentation provided by Orndance Survey:
  # http://www.ordnancesurvey.co.uk/oswebsite/gps/osnetfreeservices/furtherinfo/questdeveloper.html
  # http://www.ordnancesurvey.co.uk/oswebsite/gps/information/coordinatesystemsinfo/guidecontents/guide6.html
  #
  class Transform
    # The Airy ellipsoid used by the OSGB36 datum.
    AIRY1830 = { :a => 6377563.396, :b => 6356256.91 }
    # The GRS80 ellipsoid used by the WGS84 datum.
    GRS80 = { :a => 6378137, :b=> 6356752.3141 }

    # The northing of true origin
    N0 = -100000.0
    # The easting of true origin
    E0 = 400000.0
    # The scale factor on central meridian
    F0 = 0.9996012717
    # The latitude of true origin, in radians
    PHI0 = 49 * Math::PI / 180
    # The longitude of true origin, in radians
    LAMBDA0 = -2 * Math::PI / 180

    # Helmert transform parameters
    HELMERT_PARAMS = { 
      :tx=> -446.448, :ty=> 125.157, :tz=> -542.060, # m
      :rx=> -0.1502, :ry=> -0.2470, :rz=> -0.8421, # sec
      :s=> 20.4894 # ppm
    }

    # Decimal places to round results in degrees.
    DEGREE_ROUNDING_PLACES = 6

    ##
    # Convert an :osgb36 co-ordinate system :wgs84
    #
    # @param [Silva::System::Osgb36] osgb36 A valid :osgb36 location system.
    # @return [Silva::System::Wgs84] A valid :wgs84 location system.
    #
    def self.osgb36_to_wgs84(osgb36)
      helmert_transform(osgb36, :wgs84, AIRY1830, HELMERT_PARAMS.inject({}) { |h, (k, v)| h[k] = v * -1; h }, GRS80)
    end

    ##
    # Convert a :wgs84 co-ordinate system to :osgb36
    #
    # @param [Silva::System::Wgs84] wgs84 A valid :wgs84 location system.
    # @return [Silva::System::Osgb36] A valid :osgb36 location system.
    #
    def self.wgs84_to_osgb36(wgs84)
      helmert_transform(wgs84, :osgb36, GRS80, HELMERT_PARAMS, AIRY1830)
    end

    ##
    # Convert an :osgb36 co-ordinate system to :en (eastings and northings)
    #
    # @param [Silva::System::Osgb36] osgb36 A valid :wgs84 location system.
    # @return [Silva::System::En] A valid :en location system.
    #
    def self.osgb36_to_en(osgb36)
      self.latlong_to_en(osgb36, AIRY1830)
    end

    ##
    # Convert an OSGB36 easting, northing system to :osgb36 co-ordinate system
    #
    # @param [Silva::System::En] osgb36 A valid :en location system.
    # @return [Silva::System::Osgb36] A valid :osgb36 location system.
    #
    def self.en_to_osgb36(en)
      # Algorithm from:
      # http://www.ordnancesurvey.co.uk/oswebsite/gps/osnetfreeservices/furtherinfo/questdeveloper.html
      a, b = AIRY1830[:a], AIRY1830[:b]
      e = en.easting
      n = en.northing
      phi_prime = PHI0
      m = 0

      while n - N0 - m >= 0.0001 do
        phi_prime = (n - N0 - m) / (a * F0) + phi_prime
        m = meridional_arc(phi_prime)
      end

      nu, rho, eta2 = transverse_and_meridional_radii(phi_prime)

      vii = Math.tan(phi_prime) / (2 * rho * nu)
      viii = Math.tan(phi_prime)/(24 * rho * nu**3) * \
      (5 + 3 * Math.tan(phi_prime)**2 + eta2 - 9 * Math.tan(phi_prime)**2 * eta2)
      ix = Math.tan(phi_prime) / (720 * rho * nu**5) * (61 + 90 * Math.tan(phi_prime)**2 + 45 * Math.tan(phi_prime)**4)
      x = (1 / Math.cos(phi_prime)) / nu
      xi = (1 / Math.cos(phi_prime)) / (6 * nu**3) * (nu / rho + 2 * Math.tan(phi_prime)**2)
      xii = (1 / Math.cos(phi_prime)) / (120 * nu**5) * (5 + 28 * Math.tan(phi_prime)**2 + 24 * Math.tan(phi_prime)**4)
      xiia = (1 / Math.cos(phi_prime)) / (5040 * nu**7) * \
      (61 + 662 * Math.tan(phi_prime)**2 + 1320 * Math.tan(phi_prime)**4 + 720 * Math.tan(phi_prime)**6)

      phi = phi_prime - vii * (e - E0)**2 + viii * (e - E0)**4 - ix * (e - E0)**6
      lambda = LAMBDA0 + x * (e - E0) - xi * (e - E0)**3 + xii * (e - E0)**5 - xiia * (e - E0)**7

      System.create(:osgb36, :lat => to_deg(phi).round(DEGREE_ROUNDING_PLACES), \
                    :long => to_deg(lambda).round(DEGREE_ROUNDING_PLACES), :alt => 0)
    end


    private

    # Convert an :osgb36 or :wgs84 co-ordinate system to OSGB36 easting and northing.
    def self.latlong_to_en(system, ellipsoid)
      phi = to_rad(system.lat)
      lambda = to_rad(system.long)

      nu, rho, eta2 = transverse_and_meridional_radii(phi, ellipsoid)
      m = meridional_arc(phi, ellipsoid)
      
      i = m + N0
      ii = (nu / 2) * Math.sin(phi) * Math.cos(phi)
      iii = (nu / 24) * Math.sin(phi) * Math.cos(phi)**3 * (5 - Math.tan(phi)**2 + 9 * eta2)
      iiia = (nu / 720) * Math.sin(phi) * Math.cos(phi)**5 * (61 - 58 * Math.tan(phi)**2 + Math.tan(phi)**4)
      iv = nu * Math.cos(phi)
      v = (nu / 6) * Math.cos(phi)**3 * (nu / rho - Math.tan(phi)**2)
      vi = (nu / 120) * Math.cos(phi)**5 * \
      (5 - 18 * Math.tan(phi)**2 + Math.tan(phi)**4 + 14 * eta2 - 58 * Math.tan(phi)**4 * eta2)
      
      n = i + ii * (lambda - LAMBDA0)**2 + iii * (lambda - LAMBDA0)**4 + iiia * (lambda - LAMBDA0)**6
      e = E0 + iv * (lambda - LAMBDA0) + v * (lambda - LAMBDA0)**3 + vi * (lambda - LAMBDA0)**5
      
      System.create(:en, :easting => e.round, :northing => n.round)
    end

    # Transform to/from :osgb36/:wgs84 co-ordinate systems.
    # Algorithm from: 
    # http://www.ordnancesurvey.co.uk/oswebsite/gps/information/coordinatesystemsinfo/guidecontents/guide6.html
    # Portions of code from:
    # http://www.harrywood.co.uk/blog/2010/06/29/ruby-code-for-converting-to-uk-ordnance-survey-coordinate-systems-from-wgs84/

    def self.helmert_transform(system, target_system, ellipsoid_1, transform, ellipsoid_2)
      phi = to_rad(system.lat)
      lambda = to_rad(system.long)
      alt = system.alt
      
      a1 = ellipsoid_1[:a]
      b1 = ellipsoid_1[:b]
      
      sin_phi = Math.sin(phi)
      cos_phi = Math.cos(phi)
      sin_lambda = Math.sin(lambda)
      cos_lambda = Math.cos(lambda)
      
      e_sq1 = eccentricity_squared(ellipsoid_1)
      nu = a1 / Math.sqrt(1 - e_sq1 * sin_phi**2)
      
      x1 = (nu + alt) * cos_phi * cos_lambda
      y1 = (nu + alt) * cos_phi * sin_lambda
      z1 = ((1 - e_sq1) * nu + alt) * sin_phi
      
      tx = transform[:tx]
      ty = transform[:ty]
      tz = transform[:tz]
      rx = transform[:rx] / 3600 * Math::PI / 180 
      ry = transform[:ry] / 3600 * Math::PI / 180
      rz = transform[:rz] / 3600 * Math::PI / 180
      s1 = transform[:s] / 1e6 + 1 
      
      x2 = tx + x1 * s1 - y1 * rz + z1 * ry
      y2 = ty + x1 * rz + y1 * s1 - z1 * rx
      z2 = tz - x1 * ry + y1 * rx + z1 * s1
      
      a2 = ellipsoid_2[:a]
      b2 = ellipsoid_2[:b]
      precision = 4 / a2
      
      e_sq2 = eccentricity_squared(ellipsoid_2)
      p = Math.sqrt(x2 * x2 + y2 * y2)
      phi = Math.atan2(z2, p * (1 - e_sq2))
      phi_p = 2 * Math::PI
      
      while ((phi - phi_p).abs > precision) do
        nu = a2 / Math.sqrt(1 - e_sq2 * Math.sin(phi)**2)
        phi_p = phi
        phi = Math.atan2(z2 + e_sq2 * nu * Math.sin(phi), p)
      end

      lambda = Math.atan2(y2, x2)
      h = p / Math.cos(phi) - nu
      
      System.create(target_system, :lat => to_deg(phi).round(DEGREE_ROUNDING_PLACES),\
                    :long => to_deg(lambda).round(DEGREE_ROUNDING_PLACES), :alt => h)
    end

    # Calculate required n parameter given the relevant ellipsoid
    def self.n(ellipsoid)
      (ellipsoid[:a] - ellipsoid[:b]) / (ellipsoid[:a] + ellipsoid[:b])
    end

    # Calculate M (meridional arc) given latitude and relevant ellipsoid
    def self.meridional_arc(phi, ellipsoid = AIRY1830)
      a, b = ellipsoid[:a], ellipsoid[:b]
      n = self.n(ellipsoid)

      ma = (1 + n + (5.0 / 4.0) * n**2 + (5.0 / 4.0) * n**3) * (phi - PHI0)
      mb = (3 * n + 3 * n**2 + (21.0 / 8.0) * n**3) * Math.sin(phi - PHI0) *  Math.cos(phi + PHI0)
      mc = ((15.0 / 8.0) * n**2 + (15.0 / 8.0) * n**3) * Math.sin(2 * (phi - PHI0)) *  Math.cos(2 * (phi + PHI0))
      md = (35.0 / 24.0) * n**3 * Math.sin(3 * (phi - PHI0)) *  Math.cos(3 * (phi + PHI0))

      b * F0 * (ma - mb + mc - md)
    end

    # Calculate nu, rho, eta2 (transverse and meridional radii) given latitude and relevant ellipsoid.
    def self.transverse_and_meridional_radii(phi, ellipsoid = AIRY1830)
      a, b = ellipsoid[:a], ellipsoid[:b]
      e2 = self.eccentricity_squared(ellipsoid)

      nu = a * F0 / Math.sqrt(1 - e2 * Math.sin(phi)**2)
      rho = a * F0 * (1 - e2) / ((1 - e2 * Math.sin(phi)**2)**1.5)
      eta2 = nu / rho - 1

      [nu, rho, eta2]
    end

    # Calculate eccentricity**2 given relevant ellipsoid.
    def self.eccentricity_squared(ellipsoid)
      (ellipsoid[:a]**2 - ellipsoid[:b]**2) / ellipsoid[:a]**2
    end

    # Degrees to radians.
    def self.to_rad(degrees)
      degrees * Math::PI / 180
    end

    # Radians to degrees.
    def self.to_deg(rads)
      rads * 180 / Math::PI
    end
  end
end
