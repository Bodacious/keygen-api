# frozen_string_literal: true

module LicenseValidators
  class FingerprintScopeMismatchMatchMostValidator
    attr_reader :license, :fingerprints,:policy, :scope, :machines

    def initialize(license:,scope:)
      @scope = Hash(scope)
      @fingerprints = Array(self.scope[:fingerprint] || self.scope[:fingerprints]).compact.uniq
      @machines = license.machines.with_fingerprint(fingerprints)
      @policy = license.policy
    end

    def invalid?
      fingerprints.size > 1 && policy.machine_match_most? && machines.alive.count < (fingerprints.size / 2.0).ceil
    end

    def failure_result
      [false, "one or more fingerprint is not activated (does not match enough associated machines)", :FINGERPRINT_SCOPE_MISMATCH]
    end
  end
end
