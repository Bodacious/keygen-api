# frozen_string_literal: true

module LicenseValidators
  class FingerprintScopeMismatchMatchAnyValidator
    attr_reader :fingerprints, :machines, :policy
    def initialize(license:,scope: )
      scope = Hash(scope)
      @fingerprints = Array(scope[:fingerprint] || scope[:fingerprints]).compact.uniq
      @machines = license.machines.with_fingerprint(fingerprints)
      @policy = license.policy
    end

    def invalid?
      @fingerprints.size > 1 && @policy.machine_match_any? && @machines.alive.count == 0
    end

    def failure_result
      [false, "one or more fingerprint is not activated (does not match any associated machines)", :FINGERPRINT_SCOPE_MISMATCH]
    end
  end
end