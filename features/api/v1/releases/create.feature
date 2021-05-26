@api/v1
Feature: Create release

  Background:
    Given the following "accounts" exist:
      | Name    | Slug  |
      | Test 1  | test1 |
      | Test 2  | test2 |
    And I send and accept JSON

  Scenario: Endpoint should be inaccessible when account is disabled
    Given the account "test1" is canceled
    And I am an admin of account "test1"
    And the current account is "test1"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases"
    Then the response status should be "403"

  Scenario: Endpoint should be inaccessible when account is on free tier
    Given the account "test1" is on a free tier
    And the account "test1" is subscribed
    And I am an admin of account "test1"
    And the current account is "test1"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases"
    Then the response status should be "403"

  Scenario: Admin creates a new release for their account
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 2 "webhook-endpoints"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Launch Release",
            "key": "Product-1.0.0.dmg",
            "version": "1.0.0",
            "platform": "darwin",
            "filetype": "dmg",
            "channel": "stable"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "201"
    And the JSON response should be a "release" with the name "Launch Release"
    And the JSON response should be a "release" with the key "Product-1.0.0.dmg"
    And the JSON response should be a "release" with the version "1.0.0"
    And the JSON response should be a "release" with the platform "darwin"
    And the JSON response should be a "release" with the filetype "dmg"
    And the JSON response should be a "release" with the channel "stable"
    And sidekiq should have 2 "webhook" jobs
    And sidekiq should have 1 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates a duplicate release (by version)
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 3 "webhook-endpoints"
    And the current account has 1 "product"
    And the current account has 1 "release" for an existing "product"
    And the first "release" has the following attributes:
      """
      {
        "version": "1.0.0"
      }
      """
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Duplicate Release",
            "key": "Product-1.0.0.dmg",
            "version": "1.0.0",
            "platform": "darwin",
            "filetype": "dmg",
            "channel": "stable"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of 1 error
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "already exists",
        "code": "VERSION_TAKEN",
        "source": {
          "pointer": "/data/attributes/version"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates a duplicate release (by key)
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And the current account has 1 "release" for an existing "product"
    And the first "release" has the following attributes:
      """
      {
        "key": "Product-1.0.0.dmg"
      }
      """
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Duplicate Release",
            "key": "Product-1.0.0.dmg",
            "version": "1.0.0",
            "platform": "darwin",
            "filetype": "dmg",
            "channel": "stable"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of 1 error
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "already exists",
        "code": "KEY_TAKEN",
        "source": {
          "pointer": "/data/attributes/key"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates an alpha release
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Alpha Release",
            "key": "Product-1.0.0-alpha.1.exe",
            "version": "1.0.0-alpha.1",
            "platform": "win32",
            "filetype": "exe",
            "channel": "alpha"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "201"
    And the JSON response should be a "release" with the name "Alpha Release"
    And the JSON response should be a "release" with the key "Product-1.0.0-alpha.1.exe"
    And the JSON response should be a "release" with the version "1.0.0-alpha.1"
    And the JSON response should be a "release" with the platform "win32"
    And the JSON response should be a "release" with the filetype "exe"
    And the JSON response should be a "release" with the channel "alpha"
    And sidekiq should have 1 "webhook" job
    And sidekiq should have 1 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates an alpha release on the stable channel
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Alpha Release",
            "key": "Product-1.0.0-alpha.1.exe",
            "version": "1.0.0-alpha.1",
            "platform": "win32",
            "filetype": "exe",
            "channel": "stable"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of 1 error
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "version does not match stable channel (expected x.y.z got 1.0.0-alpha.1)",
        "code": "VERSION_CHANNEL_INVALID",
        "source": {
          "pointer": "/data/attributes/version"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates an alpha release on the beta channel
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Alpha Release",
            "key": "Product-1.0.0-alpha.1.exe",
            "version": "1.0.0-alpha.1",
            "platform": "win32",
            "filetype": "exe",
            "channel": "beta"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of 1 error
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "version does not match prerelease channel (expected x.y.z-beta.n got 1.0.0-alpha.1)",
        "code": "VERSION_CHANNEL_INVALID",
        "source": {
          "pointer": "/data/attributes/version"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates a release with a mismatched filetype
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Release Candidate #1",
            "key": "Product-2.0.0-rc.1.zip",
            "version": "2.0.0-rc.1",
            "platform": "win32",
            "filetype": "exe",
            "channel": "rc"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of 1 error
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "key extension does not match filetype (expected exe)",
        "code": "KEY_EXTENSION_INVALID",
        "source": {
          "pointer": "/data/attributes/key"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates a release with an invalid version (not a semver)
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Bad Version: Invalid",
            "key": "Product.zip",
            "version": "1.2.34.56789",
            "platform": "win32",
            "filetype": "zip",
            "channel": "stable"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of 1 error
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "must be a valid version",
        "code": "VERSION_INVALID",
        "source": {
          "pointer": "/data/attributes/version"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates a release with an invalid version (v prefix)
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "releases",
          "attributes": {
            "name": "Bad Version: Prefix",
            "key": "Product.zip",
            "version": "v1.2.34",
            "platform": "win32",
            "filetype": "zip",
            "channel": "stable"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "products",
                "id": "$products[0]"
              }
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of 1 error
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "must be a valid version",
        "code": "VERSION_INVALID",
        "source": {
          "pointer": "/data/attributes/version"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates a release with entitlement constraints
    Given I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 3 "entitlements"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "release",
          "attributes": {
            "name": "Product Version 2 (Beta)",
            "key": "Product-2.0.0-alpha1.dmg",
            "version": "2.0.0-alpha1",
            "platform": "darwin",
            "filetype": "dmg",
            "channel": "alpha"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "product",
                "id": "$products[0]"
              }
            },
            "constraints": {
              "data": [
                {
                  "type": "constraint",
                  "relationships": {
                    "entitlement": {
                      "data": { "type": "entitlement", "id": "$entitlements[0]" }
                    }
                  }
                },
                {
                  "type": "constraint",
                  "relationships": {
                    "entitlement": {
                      "data": { "type": "entitlement", "id": "$entitlements[1]" }
                    }
                  }
                }
              ]
            }
          }
        }
      }
      """
    Then the response status should be "201"
    And the JSON response should be a "release"
    And the current account should have 2 "release-entitlement-constraints"
    And the current account should have 3 "entitlements"
    And sidekiq should have 1 "webhook" job
    And sidekiq should have 1 "metric" job
    And sidekiq should have 1 "request-log" job

  Scenario: Admin creates a release with entitlement constraints that belong to another account
    Given the account "test2" has 2 "entitlements"
    And the first "entitlement" of account "test2" has the following attributes:
      """
      { "id": "2f9397b0-bbde-4219-a761-1307f338261f" }
      """
    And the second "entitlement" of account "test2" has the following attributes:
      """
      { "id": "481cc294-3f91-4efe-b471-90d14ecd5887" }
      """
    And I am an admin of account "test1"
    And the current account is "test1"
    And the current account has 1 "webhook-endpoint"
    And the current account has 1 "product"
    And I use an authentication token
    When I send a POST request to "/accounts/test1/releases" with the following:
      """
      {
        "data": {
          "type": "release",
          "attributes": {
            "name": "Product Version 2 (Beta)",
            "key": "Product-2.0.0-alpha1.dmg",
            "version": "2.0.0-alpha1",
            "platform": "darwin",
            "filetype": "dmg",
            "channel": "alpha"
          },
          "relationships": {
            "product": {
              "data": {
                "type": "product",
                "id": "$products[0]"
              }
            },
            "constraints": {
              "data": [
                {
                  "type": "constraint",
                  "relationships": {
                    "entitlement": {
                      "data": { "type": "entitlement", "id": "2f9397b0-bbde-4219-a761-1307f338261f" }
                    }
                  }
                },
                {
                  "type": "constraint",
                  "relationships": {
                    "entitlement": {
                      "data": { "type": "entitlement", "id": "481cc294-3f91-4efe-b471-90d14ecd5887" }
                    }
                  }
                }
              ]
            }
          }
        }
      }
      """
    Then the response status should be "422"
    And the JSON response should be an array of errors
    And the first error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "must exist",
        "code": "CONSTRAINTS_ENTITLEMENT_BLANK",
        "source": {
          "pointer": "/data/relationships/constraints/0/entitlement"
        }
      }
      """
    And the second error should have the following properties:
      """
      {
        "title": "Unprocessable resource",
        "detail": "must exist",
        "code": "CONSTRAINTS_ENTITLEMENT_BLANK",
        "source": {
          "pointer": "/data/relationships/constraints/1/entitlement"
        }
      }
      """
    And sidekiq should have 0 "webhook" jobs
    And sidekiq should have 0 "metric" jobs
    And sidekiq should have 1 "request-log" job
