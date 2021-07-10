# frozen_string_literal: true

json.extract! product, :id, :name, :price, :description, :picture_data, :created_at, :updated_at
json.url product_url(product, format: :json)
