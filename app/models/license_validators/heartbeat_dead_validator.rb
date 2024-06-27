# frozen_string_literal: true

module LicenseValidators
  class HeartbeatDeadValidator
    attr_reader :license, :scope
    def initialize(license:, scope: {})
      @license = license
      @scope = scope
    end

    def invalid?
      machine = license.machines.find_by(id: scope[:machine])
      machine.dead?
    end

    def failure_result
      [false, "machine heartbeat is dead", :HEARTBEAT_DEAD]
    end
  end
end
