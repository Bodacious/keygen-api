# frozen_string_literal: true

module LicenseValidators
  class BannedLicenseValidator
    attr_reader :license_updates

    def initialize(license:,**)
      @license = license
      @license_updates = {}
    end

    def invalid?
      license.banned?
    end

    def result
      [false, "banned", :banned]
    end
  end
end
