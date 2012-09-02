module Silva
  ##
  # Indicates that an invalid system name has been passed.
  class InvalidSystemError < StandardError; end
  ##
  # Indicates that an invalid transform has been attempted.
  class InvalidTransformError < StandardError; end
  ##
  # Indicates that an invalid parameter has been passed.
  class InvalidParamError < StandardError; end
  ##
  # Indicates that an invalid parameter value has been passed.
  class InvalidParamValueError < StandardError; end
  ##
  # Indicates that an insufficient parameters have been passed.
  class InsufficientParamsError < StandardError; end
end
