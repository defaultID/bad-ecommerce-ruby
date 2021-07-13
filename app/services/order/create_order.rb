# frozen_string_literal: true

class Order
  class CreateOrder < BaseService
    private

    def _call(user:)
      basket_items = user.basketed

      Order.transaction do
        order = Order.create!(user: user)

        basket_items.each do |basket_item|
          order.items.create!(
            product: basket_item.product,
            price: basket_item.product.price,
            count: basket_item.count
          )
        end

        order
      rescue StandardError => e
        Rails.logger.error "Cannot create order:\n#{e.inspect}"
        nil
      end
    end
  end
end
