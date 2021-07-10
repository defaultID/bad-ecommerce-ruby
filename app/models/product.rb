# frozen_string_literal: true

class Product < ApplicationRecord
  def picture_path
    "/uploads/products/#{id}/#{picture}" if picture.present?
  end
end
