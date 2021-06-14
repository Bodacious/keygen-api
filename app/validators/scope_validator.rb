# frozen_string_literal: true

class ScopeValidator < ActiveModel::EachValidator
  def validate_each(parent, name, child)
    return if child.nil?

    key = options.fetch(:by).to_s

    parent.errors.add(name, :blank, message: 'must exist') unless
      parent.attributes[key] == child.attributes[key]
  end
end