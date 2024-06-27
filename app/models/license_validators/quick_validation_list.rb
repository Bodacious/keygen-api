module LicenseValidators
  class QuickValidationList < DelegateClass(Array)
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
