module LicenseValidators
  class EntitlementsScopeEmptyValidator
    attr_reader :license, :scope
    def initialize(license:, scope: {})
      @license, @scope = license, scope
    end

    def invalid?
      scope.present? && scope.key?(:entitlements) && scope[:entitlements].uniq.empty?
    end

    def failure_result
      [false, "entitlements scope is empty", :ENTITLEMENTS_SCOPE_EMPTY]
    end
  end
end