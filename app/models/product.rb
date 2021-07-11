# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :baskets, dependent: :destroy

  def picture_path
    "/uploads/products/#{id}/#{picture}" if picture.present?
  end
end
