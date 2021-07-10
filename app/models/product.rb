# frozen_string_literal: true

class Product < ApplicationRecord
  def picture_path
    "/uploads/products/#{id}/#{picture}"
  end
end
