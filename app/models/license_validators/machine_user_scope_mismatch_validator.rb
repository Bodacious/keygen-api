# frozen_string_literal: true

module LicenseValidators
  class MachineUserScopeMismatchValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      return false if scope.nil? || !scope.key?(:machine)

      machine = license.machines.find_by(id: scope[:machine])
      user = scope[:user]

      !(user.nil? || !machine.owner_id? || machine.owner_id == user || machine.owner.email == user)
    end

    def failure_result
      [false, "user scope does not match (does not match associated machine owner)",
       :USER_SCOPE_MISMATCH]
    end
  end
end
