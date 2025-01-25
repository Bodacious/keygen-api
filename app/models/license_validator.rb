# frozen_string_literal: true

class LicenseValidator

  def initialize(license:, scope: nil, validators_list: [])
    @account = license&.account
    @product = license&.product
    @license = license
    @scope = scope
    @validators = validators_list.lazy.map { |validator_class| validator_class.new(license:, scope:) }
  end

  def run_all_validation_checks!
    validate!
  end

  private

  attr_reader :account,
              :product,
              :license,
              :scope,
              :validators

  def validate!
    first_invalid_validator = validators.find(&:invalid?)
    return first_invalid_validator.failure_result if first_invalid_validator

    [true, "is valid", :VALID]
  end
end
