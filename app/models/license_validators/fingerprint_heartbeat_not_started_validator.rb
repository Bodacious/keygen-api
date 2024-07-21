# frozen_string_literal: true

module LicenseValidators
  class FingerprintHeartbeatNotStartedValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope:)
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      (scope.key?(:fingerprint) || scope.key?(:fingerprints)) &&
          license.policy.require_heartbeat? &&
          alive_machines.any?(&:not_started?)
    end

    def failure_result
      [false, 'machine heartbeat is required', :HEARTBEAT_NOT_STARTED]
    end
  end
end
