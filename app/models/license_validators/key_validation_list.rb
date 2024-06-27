# frozen_string_literal: true

module LicenseValidators
  class KeyValidationList < DelegateClass(Array)
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
              LicenseValidators::EntitlementsScopeValidator,
              LicenseValidators::MachineScopeRequiredValidator,
              LicenseValidators::NoMachineValidator,
              LicenseValidators::MachineUserScopeMismatchValidator,
              LicenseValidators::HeartbeatNotStartedValidator,
              LicenseValidators::HeartbeatDeadValidator,
            ])
    end
  end
end
