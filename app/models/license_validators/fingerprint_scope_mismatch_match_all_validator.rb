# frozen_string_literal: true

module LicenseValidators
  class FingerprintScopeMismatchMatchAllValidator
    attr_reader :machines, :fingerprints, :policy, :scope
    def initialize(license:,scope: )
      @scope = Hash(scope)
      @fingerprints = Array(self.scope[:fingerprint] || self.scope[:fingerprints]).compact.uniq
      @machines = license.machines.with_fingerprint(fingerprints)
      @policy = license.policy
    end

    def invalid?
      return false unless scope[:fingerprint] || scope[:fingerprints]

      fingerprints.size > 1 && policy.machine_match_all? && machines.alive.count < fingerprints.size
    end

    def failure_result
      [false, "one or more fingerprint is not activated (does not match all associated machines)", :FINGERPRINT_SCOPE_MISMATCH]
    end
  end
end
