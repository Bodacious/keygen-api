# frozen_string_literal: true

module LicenseValidators
  class ProductScopeMismatchValidator
    attr_reader :license
    attr_reader :scope
    def initialize(license:, scope: {})
      @license = license
      @scope = scope
    end

    def invalid?
      scope.present? && scope.key?(:product) && license.product.id != scope[:product]
    end

    def failure_result
      return [false, "product scope does not match", :PRODUCT_SCOPE_MISMATCH]
    end
  end
end
