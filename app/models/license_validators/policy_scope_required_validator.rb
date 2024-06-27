module LicenseValidators
  class PolicyScopeRequiredValidator

    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = scope
    end

    def invalid?
      !(scope.present? && scope.key?(:policy)) && license.policy.require_policy_scope?
    end

    def failure_result
      [false, "policy scope is required", :POLICY_SCOPE_REQUIRED]
    end
  end
end
