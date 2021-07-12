# frozen_string_literal: true

class Basket
  class AddProduct < BaseService
    option :user

    private

    def _call(product:, count:)
      basket = Basket.find_or_initialize_by(
        user_id: user.id,
        product_id: product.id
      )
      basket.with_lock do
        basket.count += count.to_i
        basket.save
      end
    end
  end
end
