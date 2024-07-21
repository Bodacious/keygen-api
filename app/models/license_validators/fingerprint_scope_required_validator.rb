# frozen_string_literal: true

module LicenseValidators
  class FingerprintScopeRequiredValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      return false unless license.policy.require_fingerprint_scope?

      scope.slice(:fingerprint, :fingerprints).empty?
    end

    def failure_result
      [false, "fingerprint scope is required", :FINGERPRINT_SCOPE_REQUIRED]
    end
  end
end
