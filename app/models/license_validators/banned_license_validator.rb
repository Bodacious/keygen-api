# frozen_string_literal: true

module LicenseValidators
  class BannedLicenseValidator
    attr_reader :license

    def initialize(license:, **)
      @license = license
    end

    def invalid?
      license.banned?
    end

    def failure_result
      [false, "is banned", :BANNED]
    end
  end
end
