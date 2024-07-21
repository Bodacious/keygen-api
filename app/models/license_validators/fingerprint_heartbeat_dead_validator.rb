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
      return false unless (scope.present? && (scope.key?(:fingerprint) || scope.key?(:fingerprints)))

      fingerprints = Array(scope[:fingerprint] || scope[:fingerprints]).compact.uniq
      Rails.logger.info("Invalid? called: #{fingerprints}")
      machines = license.machines.with_fingerprint(fingerprints)

      dead_machines = machines.dead
      Rails.logger.info("Dead machines: #{dead_machines.inspect}")
      dead_machines.count == fingerprints.size
    end

    def failure_result
      [false, 'machine heartbeat is dead', :HEARTBEAT_DEAD]
    end
  end
end
