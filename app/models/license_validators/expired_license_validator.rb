# frozen_string_literal: true

module LicenseValidators
  class ExpiredLicenseValidator
    attr_reader :license

    def initialize(license:, **)
      @license = license
    end

    def invalid?
      license.revoke_access? &&
        license.expired?
    end

    def failure_result
      [false, "is expired", :EXPIRED]
    end
  end
end
