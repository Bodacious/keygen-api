# frozen_string_literal: true

module LicenseValidators
  class SuspendedLicenseValidator
    attr_reader :license_updates

    def initialize(license:, **)
      @license = license
      @license_updates = {}
    end

    def invalid?
      license.suspended?
    end

    def result
      [false, "is suspended", :SUSPENDED]
    end
  end
end
