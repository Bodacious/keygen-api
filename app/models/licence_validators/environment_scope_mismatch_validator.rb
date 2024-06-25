# frozen_string_literal: true

module LicenseValidators
  class EnvironmentScopeMismatchValidator
    def initialize(license:, scope:)
      @license = license
      @scope = scope
    end

    def invalid?
      scope.present? && scope.key?(:environment) and !(
        license.environment&.code == scope[:environment] || license.environment&.id == scope[:environment]
      )
    end

    def result
      [false, "environment scope does not match", :ENVIRONMENT_SCOPE_MISMATCH]
    end
  end
end
