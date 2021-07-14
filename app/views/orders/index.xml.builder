# frozen_string_literal: true

xml.instruct!
xml.orders do
  xml.dateStart @date_start
  xml.dateEnd @date_end

  xml.list do
    @orders.each do |order|
      xml.order do
        xml.id order.id
        xml.status order.status
        xml.paymentMethod order.payment_method
        xml.totalCost order.total_cost
        xml.createdAt order.created_at.rfc3339

        xml.items do
          order.items.each do |item|
            xml.item do
              xml.productName item.product_name
              xml.price item.price
              xml.count item.count
            end
          end
        end
      end
    end
  end
end
