# frozen_string_literal: true

module LicenseValidators
  class MachineScopeMismatchValidator
    attr_reader :license, :scope

    def initialize(license:, scope: {})
      @license = license
      @scope = license
    end

    def invalid?
      license.machines.find_by(id: scope[:machine]).present?
    end

    def failure_result
      [false, "machine is not activated (does not match any associated machines)", :MACHINE_SCOPE_MISMATCH]
    end
  end
end
