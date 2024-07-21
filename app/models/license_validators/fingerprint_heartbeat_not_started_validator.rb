# frozen_string_literal: true

module LicenseValidators
  class FingerprintHeartbeatNotStartedValidator
    attr_reader :license
    attr_reader :scope
    attr_reader :policy

    def initialize(license:, scope:)
      @license = license
      @alive_machines = license.machines
      @policy = license.policy
      @scope = Hash(scope)
    end

    def invalid?
      return false unless scope.key?(:fingerprint) || scope.key?(:fingerprints)

      fingerprints = Array(scope[:fingerprint] || scope[:fingerprints]).compact.uniq
      alive_machines = license.machines.with_fingerprint(fingerprints).alive
      policy.require_heartbeat? && alive_machines.any?(&:not_started?)
    end

    def failure_result
      [false, "machine heartbeat is required", :HEARTBEAT_NOT_STARTED]
    end
  end
end
