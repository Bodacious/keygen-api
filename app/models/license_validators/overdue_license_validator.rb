# frozen_string_literal: true

module LicenseValidators
  # Check if license is overdue for check in

  class OverdueLicenseValidator
    attr_reader :license

    def initialize(license:, **)
      @license = license
    end

    def invalid?
      license.check_in_overdue?
    end

    def failure_result
      [false, "is overdue for check in", :OVERDUE]
    end
  end
end
