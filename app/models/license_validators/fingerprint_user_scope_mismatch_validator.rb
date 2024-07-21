# frozen_string_literal: true

module LicenseValidators
  class FingerprintUserScopeMismatchValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope:)
      @license = license
      @scope = scope
      @fingerprints = Hash(scope).slice(:fingerprint, :fingerprints).values.first
    end

    def invalid?
      return false if scope.nil?
      return false if !scope.key?(:fingerprint) && !scope.key?(:fingerprints)

      fingerprints = Array(scope[:fingerprint] || scope[:fingerprints]).compact
                                                                       .uniq
      machines = license.machines.with_fingerprint(fingerprints)
      user = scope[:user]
      alive_machines = machines.alive

      !(user.nil? || alive_machines.for_owner(user).union(alive_machines.for_owner(nil)).count == alive_machines.count)
    end

    def failure_result
      [false, "user scope does not match (does not match associated machine owners)",
       :USER_SCOPE_MISMATCH]
    end
  end
end
