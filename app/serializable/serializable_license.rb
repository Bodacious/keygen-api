class SerializableLicense < SerializableBase
  type :licenses

  attribute :key, unless: -> { @object.raw.nil? || @object.key.nil? } do
    if @object.policy.encrypted?
      @object.raw
    else
      @object.key
    end
  end
  attribute :expiry
  attribute :metadata
  attribute :created do
    @object.created_at
  end
  attribute :updated do
    @object.updated_at
  end

  relationship :account do
    link :related do
      @url_helpers.v1_account_path @object.account
    end
  end
  relationship :product do
    link :related do
      @url_helpers.v1_account_product_path @object.account, @object.product
    end
  end
  relationship :policy do
    link :related do
      @url_helpers.v1_account_policy_path @object.account, @object.policy
    end
  end
  relationship :user, unless: -> { @object.user.nil? } do
    link :related do
      # TODO: https://github.com/jsonapi-rb/jsonapi-serializable/issues/49
      @url_helpers.v1_account_user_path @object.account, @object.user if @object.user
    end
  end
  relationship :machines do
    link :related do
      @url_helpers.v1_account_machines_path @object.account, license: @object.id
    end
  end

  link :self do
    @url_helpers.v1_account_license_path @object.account, @object
  end
end
