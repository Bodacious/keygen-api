# frozen_string_literal: true

module LicenseValidators
  class IdValidationList < DelegateClass(Array)
    def initialize
      super([
        LicenseValidators::NotFoundValidator,
        LicenseValidators::BannedLicenseValidator,
        LicenseValidators::SuspendedLicenseValidator,
        LicenseValidators::ExpiredLicenseValidator,
        LicenseValidators::OverdueLicenseValidator,
        LicenseValidators::EnvironmentScopeMismatchValidator,
        LicenseValidators::EnvironmentRequiredValidator,
        LicenseValidators::ProductScopeRequiredValidator,
        LicenseValidators::ProductScopeMismatchValidator,
        LicenseValidators::PolicyScopeRequiredValidator,
        LicenseValidators::PolicyScopeMismatchValidator,
        LicenseValidators::UserScopeRequiredValidator,
        LicenseValidators::UserScopeMismatchValidator,
        LicenseValidators::EntitlementsMissingValidator,
        LicenseValidators::EntitlementsScopeEmptyValidator,
        LicenseValidators::MachineScopeRequiredValidator,
        LicenseValidators::NoMachineValidator,
        LicenseValidators::MachineScopeMismatchValidator,
        LicenseValidators::MachineUserScopeMismatchValidator,
        LicenseValidators::MachineHeartbeatNotStartedValidator,
        LicenseValidators::MachineHeartbeatDeadValidator,
        LicenseValidators::FingerprintScopeRequiredValidator,
        LicenseValidators::FingerprintScopeEmptyValidator,
        LicenseValidators::FingerprintNoMachineValidator,
        LicenseValidators::FingerprintHeartbeatDeadValidator,
        # scope mismatch validators
        LicenseValidators::FingerprintScopeMismatchMatchMostValidator,
        LicenseValidators::FingerprintScopeMismatchMatchTwoValidator,
        LicenseValidators::FingerprintScopeMismatchMatchAllValidator,
        LicenseValidators::FingerprintScopeMismatchMatchAnyValidator,
        LicenseValidators::FingerprintScopeMismatchValidator,

        LicenseValidators::FingerprintUserScopeMismatchValidator,
        LicenseValidators::FingerprintHeartbeatNotStartedValidator
      ])
    end
  end
end
