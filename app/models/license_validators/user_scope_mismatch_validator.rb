module LicenseValidators
  class UserScopeMismatchValidator
    attr_reader :license, :user_identifier, :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      return false unless scope.key?(:user)

      user_identifier= scope[:user]

      puts "Invalid?"
      puts "user_identifier: #{scope.fetch(:user)}"
      puts "owner_id: #{license.owner_id}"
      puts "id exist?: #{license.users.where(id: user_identifier).exists?}"
      puts "email exist?: #{license.users.where(email: user_identifier).exists?}"
      puts ""
      return false if license.owner_id == user_identifier

      license.users.where(id: user_identifier)
                 .or(license.users.where(email: user_identifier),)
                 .none?
    end

    def failure_result
      [false, "user scope does not match", :USER_SCOPE_MISMATCH]
    end
  end
end