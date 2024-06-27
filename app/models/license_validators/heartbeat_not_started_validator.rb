# frozen_string_literal: true

module LicenseValidators
  class HeartbeatNotStartedValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {} )
      @license = license
      @scope = scope
    end

    def invalid?
      machine = license.machines.find_by(id: scope[:machine])
      license.policy.require_heartbeat? && machine.heartbeat_not_started?
    end

    def failure_result
      [false, 'machine heartbeat is required', :HEARTBEAT_NOT_STARTED]
    end
  end
end
