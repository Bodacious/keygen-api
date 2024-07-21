# frozen_string_literal: true

module LicenseValidators
  class FingerprintScopeMismatchMatchTwoValidator
    attr_reader :fingerprints, :machines, :policy


    def initialize(license:,scope:)
      scope = Hash(scope)
      @fingerprints = Array(scope[:fingerprint] || scope[:fingerprints]).compact.uniq
      @machines = license.machines.with_fingerprint(fingerprints)
      @policy = license.policy
    end

    def invalid?
      fingerprints.size > 1 && policy.machine_match_two? && machines.alive.count < 2
    end

    def failure_result
      [false, "one or more fingerprint is not activated (does not match at least 2 associated machines)", :FINGERPRINT_SCOPE_MISMATCH]
    end
  end
end
