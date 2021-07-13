# frozen_string_literal: true

class Order
  class ConfirmShipment < BaseService
    private

    def _call(order:)
      if order.confirmed_status?
        order.update!(
          status: :shipped,
          shipped_at: DateTime.now
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
