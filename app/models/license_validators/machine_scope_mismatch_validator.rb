# frozen_string_literal: true

module LicenseValidators
  class MachineScopeMismatchValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      return false if scope.nil? || !scope.key?(:machine)
      return false if license.machines_count.zero?

      license.machines.find_by(id: scope[:machine]).nil?
    end

    def failure_result
      [false, "machine is not activated (does not match any associated machines)",
       :MACHINE_SCOPE_MISMATCH]
    end
  end
end
