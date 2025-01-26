# frozen_string_literal: true

module LicenseValidators
  class FingerprintNoMachineValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = scope
    end

    def invalid?
      scope.present? && (scope.key?(:fingerprint) || scope.key?(:fingerprints)) && license.machines_count.zero?
    end

    def failure_result
      if license.policy.floating?
        [false, "fingerprint is not activated (has no associated machines)", :NO_MACHINES]
      else
        [false, "fingerprint is not activated (has no associated machine)", :NO_MACHINE]
      end
    end
  end
end
