module LicenseValidators
  class NotFoundValidator
    attr_reader :license_updates

    def initialize(license:, **)
      @license = license
      @license_updates = {}
    end

    def invalid?
      license.nil?
    end

    def result
      [false, "does not exist", :NOT_FOUND]
    end
  end
end
