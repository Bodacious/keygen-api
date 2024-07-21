module LicenseValidators
  class FingerprintScopeEmptyValidator
    attr_reader :license, :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      fingerprints = Array(scope[:fingerprint] || scope[:fingerprints]).compact.uniq

      (scope.present? && (scope.key?(:fingerprint) || scope.key?(:fingerprints))) && fingerprints.empty?
    end

    def failure_result
      [false, "fingerprint scope is empty", :FINGERPRINT_SCOPE_EMPTY]
    end
  end
end