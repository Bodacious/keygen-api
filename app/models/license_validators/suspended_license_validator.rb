# frozen_string_literal: true

module LicenseValidators
  class SuspendedLicenseValidator
    attr_reader :license

    def initialize(license:, **)
      @license = license
    end

    def invalid?
      license.suspended?
    end

    def failure_result
      [false, "is suspended", :SUSPENDED]
    end
  end
end
