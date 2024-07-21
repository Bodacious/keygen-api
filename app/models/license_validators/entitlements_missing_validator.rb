# frozen_string_literal: true

module LicenseValidators
  class EntitlementsMissingValidator
    attr_reader :license
    attr_reader :entitlements

    def initialize(license:, scope:)
      @license = license
      scope = Hash(scope)
      @entitlements = Array(scope[:entitlements]).uniq
    end

    def invalid?
      license.entitlements.where(code: entitlements).count != entitlements.size
    end

    def failure_result
      [false, "is missing one or more required entitlements", :ENTITLEMENTS_MISSING]
    end
  end
end
