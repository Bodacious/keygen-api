# frozen_string_literal: true

module LicenseValidators
  class MachineScopeRequiredValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      !(scope.present? && scope.key?(:machine)) && license.policy.require_machine_scope?
    end

    def failure_result
      [false, "machine scope is required", :MACHINE_SCOPE_REQUIRED]
    end
  end
end
