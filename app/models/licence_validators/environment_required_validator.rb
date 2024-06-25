# frozen_string_literal: true

module LicenseValidators
  class EnvironmentRequiredValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope:)
      @license = license
      @scope = scope
    end

    def invalid?
      scope.present? && scope.key?(:environment) && license.policy.require_environment_scope?
    end

    def result
      [false, "environment scope is required", :ENVIRONMENT_SCOPE_REQUIRED]
    end
  end
end
