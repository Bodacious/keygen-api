# frozen_string_literal: true

module LicenseValidators
  class FingerprintScopeMismatchValidator
    attr_reader :alive_machines
    attr_reader :scope

    def initialize(license:, scope:)
      @scope = Hash(scope)
      fingerprints = Array(@scope[:fingerprint] || @scope[:fingerprints]).compact.uniq
      @alive_machines = license.machines.with_fingerprint(fingerprints).alive
    end

    def invalid?
      return false unless scope[:fingerprint] || scope[:fingerprints]

      alive_machines.count.zero?
    end

    def failure_result
      [false, "fingerprint is not activated (does not match any associated machines)",
       :FINGERPRINT_SCOPE_MISMATCH]
    end
  end
end
