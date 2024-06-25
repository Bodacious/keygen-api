# frozen_string_literal: true

module LicenseValidators
  class IdValidationsList < DelegateClass(Array)
    def initialize
      super([
        LicenseValidators::NotFoundValidator,
        LicenseValidators::BannedLicenseValidator,
        LicenseValidators::SuspendedLicenseValidator,
        LicenseValidators::ExpiredLicenseValidator,
        LicenseValidators::OverdueLicenseValidator,
        LicenseValidators::EnvironmentScopeMismatchValidator,
        LicenseValidators::EnvironmentRequiredValidator
      ])
    end
  end
end
