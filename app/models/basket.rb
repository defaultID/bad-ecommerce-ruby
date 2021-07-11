# frozen_string_literal: true

class Basket < ApplicationRecord
  belongs_to :user, inverse_of: :basketed
  belongs_to :product

  validates :count, numericality: { only_integer: true, greater_than: 0 }

  def items_cost
    product.price * count
  end

  def self.total_cost
    sum(&:items_cost)
  end
end
