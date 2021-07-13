# frozen_string_literal: true

class Order
  class Item < ApplicationRecord
    belongs_to :order
    belongs_to :product

    def product_name
      product.present? ? product.name : 'Deleted product'
    end

    def items_cost
      price * count
    end
  end
end
