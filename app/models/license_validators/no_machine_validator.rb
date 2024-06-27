# frozen_string_literal: true

module LicenseValidators
  class NoMachineValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = scope
    end

    def invalid?
      scope.present? && scope.key?(:machine) && license.machines_count.zero?
    end

    def failure_result
      if !license.policy.floating?
        [false, "machine is not activated (has no associated machine)", :NO_MACHINE]
      else
        [false, "machine is not activated (has no associated machines)", :NO_MACHINES]
      end
    end
  end
end
