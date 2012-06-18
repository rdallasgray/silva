module Silva
  ##
  # A location system -- :wgs84, :osgb36, :en or :gridref.
  module System
    ##
    # A factory method to simplify and moderate creation of location systems.
    # @param [Symbol] system_name The name of the system to be created.
    # @param [Hash] options Parameters relevant to the given system.
    # @return [Silva::System] A valid location system.
    # @raises Silva::InvalidSystemError If the given system can't be created.
    def self.create(system_name, options)
      system = Silva::System.const_get(system_name.to_s.capitalize)
      system.new(options)
    rescue NameError
      raise Silva::InvalidSystemError, "Can't create system: #{system_name}"
    end

    ##
    # Provides basic utility functions.
    #
    class Base
      # Default parameters can be specified for each system.
      DEFAULT_PARAMS = {}
      # Some parameters must be given
      REQUIRED_PARAMS = []

      ##
      # Create the given system with relevant options.
      #
      # @param [Hash] options Parameters relevant to the given system.
      #
      def initialize(options)
        @system_name = self.class.name.split('::').last.downcase.to_sym
        options = self.class::DEFAULT_PARAMS.merge(options)
        params_satisfied?(options)
        options.each {|param, val| set_param(param, val) }
      end

      ##
      # Transforms the base system to a different system.
      # 
      # @param [Symbol] target_system_name The system to convert to.
      # @param [Hash] options Parameters relevant to the target system.
      # @return [Silva::System] A new location system of type target_system_name.
      def to(target_system_name, options = nil)
        return self if target_system_name == @system_name
        to_method = "to_#{target_system_name}".to_sym
        unless respond_to?(to_method, true)
          raise Silva::InvalidTransformError, "#{@system_name} cannot be transformed to #{target_system_name}."
        end
        send(to_method, options)
      end

      private

      # Set the params given in options, if they pass validation.
      def set_param(param, val)
        val_method = "validate_#{param}".to_sym
        raise Silva::InvalidParamError, "Invalid param: #{param}." unless respond_to?(val_method, true)
        raise Silva::InvalidParamValueError, "Invalid #{param}: #{val}." unless (send(val_method, val))
        instance_variable_set("@#{param}", val)
      end

      def params_satisfied?(options)
        raise Silva::InsufficientParamsError unless self.class::REQUIRED_PARAMS & options.keys == self.class::REQUIRED_PARAMS
      end
    end
  end
end
