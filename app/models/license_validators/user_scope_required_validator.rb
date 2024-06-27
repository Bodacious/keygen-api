module LicenseValidator
  class UserScopeRequiredValidator
    attr_reader :license
    attr_reader :scope
    def initialize(license:, scope: {})
      @license = license
      @scope = scope
    end

    def invalid?
      !(scope.present? && scope.key?(:user)) && license.policy.require_user_scope?
    end

    def failure_result
      [false, "user scope is required", :USER_SCOPE_REQUIRED]
    end
  end
end