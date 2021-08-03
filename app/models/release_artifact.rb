# frozen_string_literal: true

class ReleaseArtifact < ApplicationRecord
  include Limitable
  include Pageable

  belongs_to :account
  belongs_to :product
  belongs_to :release
  has_many :users,
    through: :product
  has_many :licenses,
    through: :product

  validates :account,
    presence: { message: 'must exist' }
  validates :product,
    presence: { message: 'must exist' },
    scope: { by: :account_id }
  validates :release,
    presence: { message: 'must exist' },
    scope: { by: :account_id }

  scope :for_product, -> product {
    where(product: product)
  }

  scope :for_user, -> user {
    joins(:users).where(users: { id: user })
  }

  scope :for_license, -> license {
    joins(:licenses).where(licenses: { id: license })
  }
end