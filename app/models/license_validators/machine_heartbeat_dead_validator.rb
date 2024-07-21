# frozen_string_literal: true

module LicenseValidators
  class MachineHeartbeatDeadValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope:)
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      return false unless scope.key?(:machine)
      return false if license.machines_count.zero?

      machine = license.machines.find(scope[:machine])
      machine.dead?
    end

    def failure_result
      [false, "machine heartbeat is dead", :HEARTBEAT_DEAD]
    end
  end
end
