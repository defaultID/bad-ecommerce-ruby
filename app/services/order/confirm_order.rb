# frozen_string_literal: true

class Order
  class ConfirmOrder < BaseService
    private

    def _call(order:)
      if order.paid_status?
        order.confirmed_status!
      else
        false
      end
    end
  end
end
