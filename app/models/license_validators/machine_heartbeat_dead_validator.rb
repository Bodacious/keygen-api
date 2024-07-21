# frozen_string_literal: true

module LicenseValidators
  class MachineHeartbeatDeadValidator
    attr_reader :license, :scope

    def initialize(license:, scope:)
      @license = license
      @scope = scope
    end

    def invalid?
      return false if scope.nil? || scope[:machine]
      return false if license.machines_count.zero?
      machine = license.machines.find_by(id: scope[:machine])

      return false if machine.nil?
      machine.dead?
    end

    def failure_result
      [false, "machine heartbeat is dead", :HEARTBEAT_DEAD]
    end
  end
end
