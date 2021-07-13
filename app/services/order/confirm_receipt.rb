# frozen_string_literal: true

class Order
  class ConfirmReceipt < BaseService
    private

    def _call(order:)
      if order.shipped_status?
        order.update!(
          status: :received,
          received_at: DateTime.now
        )
      else
        false
      end
    rescue StandardError => e
      Rails.logger.error "Cannot pay this order:\n#{e.inspect}"
      false
    end
  end
end
