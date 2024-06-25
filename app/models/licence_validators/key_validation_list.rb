# frozen_string_literal: true

module LicenseValidators
  class KeyValidationList < DelegateClass(Array)
    def initialize
      super([
        LicenseValidators::NotFoundValidator,
        LicenseValidators::BannedLicenseValidator,
        LicenseValidators::SuspendedLicenseValidator,
        LicenseValidators::ExpiredLicenseValidator,
        LicenseValidators::OverdueLicenseValidator
      ])
    end
  end
end
