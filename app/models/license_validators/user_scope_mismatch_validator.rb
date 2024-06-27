module LicenseValidators
  class UserScopeMismatchValidator
    attr_reader :license, :scope
    def initialize(license:, scope: {})
      @license = license
      @scope = scope
    end

    def invalid?
      scope.present? && scope.key?(:user) || license.owner_id == scope[:user] ||
          license.users.where(id: scope[:user])
                 .or(
                   license.users.where(email: scope[:user]),
                   )
                 .exists?
    end

    def failure_result
      [false, "user scope does not match", :USER_SCOPE_MISMATCH]
    end
  end
end