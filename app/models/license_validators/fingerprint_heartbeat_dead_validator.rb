# frozen_string_literal: true

module LicenseValidators
  class FingerprintHeartbeatDeadValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      invalid_result
    end

    def invalid_result
      return false unless scope.key?(:fingerprint) || scope.key?(:fingerprints)

      fingerprints = Array(scope[:fingerprint] || scope[:fingerprints]).compact.uniq
      machines = license.machines.with_fingerprint(fingerprints)
      dead_machines = machines.dead
      dead_machines.count == fingerprints.size
    end

    def failure_result
      [false, "machine heartbeat is dead", :HEARTBEAT_DEAD]
    end
  end
end
