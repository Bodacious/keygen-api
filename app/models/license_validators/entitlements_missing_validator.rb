# frozen_string_literal: true

module LicenseValidators
  class EntitlementsMissingValidator
    attr_reader :license, :scope
    def initialize(license:, scope: {})
      @license= license
      @scope = scope
    end

    def invalid?
      entitlements = scope[:entitlements].uniq

      !(scope.present? && scope.key?(:entitlements)) && license.entitlements.where(code: entitlements).count != entitlements.size
    end

    def failure_result
      [false, "is missing one or more required entitlements", :ENTITLEMENTS_MISSING]
    end
  end
end
