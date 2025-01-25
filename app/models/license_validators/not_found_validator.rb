module LicenseValidators
  class NotFoundValidator
    attr_reader :license_updates
    attr_reader :license

    def initialize(license:, **)
      @license = license
    end

    def invalid?
      license.nil?
    end

    def failure_result
      [false, "does not exist", :NOT_FOUND]
    end
  end
end
