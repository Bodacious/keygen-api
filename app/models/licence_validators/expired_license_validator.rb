# frozen_string_literal: true

module LicenseValidators
  class ExpiredLicenseValidator
    def invalid?
      license.revoke_access? &&
        license.expired?
    end

    def result
      [false, "is expired", :EXPIRED]
    end
  end
end
