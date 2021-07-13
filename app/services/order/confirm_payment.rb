# frozen_string_literal: true

class Order
  class ConfirmPayment < BaseService
    private

    # In real world this would use payment processor API to validate if the key was valid
    # and get a real transaction id, but we'll just pretend that the key is the transaction id
    def _call(order:, method:, key:)
      Rails.logger.info "Paying for order #{order.id} with #{method} method"

      Order.transaction do
        order.update!(
          payment_method: method,
          payment_id: key,
          status: :paid
        )
      rescue StandardError => e
        Rails.logger.error "Cannot pay this order:\n#{e.inspect}"
        false
      end
    end
  end
end
