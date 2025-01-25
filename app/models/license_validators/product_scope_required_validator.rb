# frozen_string_literal: true

module LicenseValidators
  class ProductScopeRequiredValidator
    attr_reader :license
    attr_reader :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = Hash(scope)
    end

    def invalid?
      !(scope.present? && scope.key?(:product)) && license.policy.require_product_scope?
    end

    def failure_result
      [false, "product scope is required", :PRODUCT_SCOPE_REQUIRED]
    end
  end
end
