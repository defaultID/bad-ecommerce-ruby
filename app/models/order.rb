# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'Order::Item', dependent: :destroy

  enum status: {
    new: 0,
    pending: 10,
    paid: 20,
    confirmed: 30,
    shipped: 40,
    received: 50,
    cancelled: 120,
  }, _suffix: true

  enum payment_method: {
    dummy: 10,
  }, _suffix: true, _scopes: false

  def total_cost
    if items.loaded?
      # Use item method to calculate cost
      items.sum(&:items_cost)
    else
      # Assume that we won't load all items and use SQL to calculate cost
      items.sum('price * count')
    end
  end

  def expired?
    status_before_type_cast < self.class.statuses[:paid] && created_at < 1.hour.ago
  end

  %i[paid shipped received].each do |status_type|
    status_id = statuses[status_type]

    define_method :"#{status_type}?" do
      !cancelled_status? && status_for_database >= status_id
    end
  end
end
