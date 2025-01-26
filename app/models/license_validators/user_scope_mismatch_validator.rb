module LicenseValidators
  class UserScopeMismatchValidator
    attr_reader :license
    attr_reader :user_identifier
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      return false unless scope.key?(:user)

      user_identifier = scope[:user]
      return false if license.owner_id == user_identifier

      license.users.where(id: user_identifier)
             .or(license.users.where(email: user_identifier))
             .none?
    end

    def failure_result
      [false, "user scope does not match", :USER_SCOPE_MISMATCH]
    end
  end
end
