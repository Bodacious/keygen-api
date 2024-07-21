module LicenseValidators
  class PolicyScopeMismatchValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
      @policy = license.policy
    end

    def invalid?
      scope.key?(:policy) && license.policy_id != scope[:policy]
    end

    def failure_result
      [false, "policy scope does not match", :POLICY_SCOPE_MISMATCH]
    end
  end
end
