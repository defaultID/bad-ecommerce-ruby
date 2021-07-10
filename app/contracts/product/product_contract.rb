# frozen_string_literal: true

class Product
  class ProductContract < BaseContract
    params do
      optional(:picture).maybe(type?: ActionDispatch::Http::UploadedFile)
      required(:name).filled(:string)
      required(:price).filled(:decimal)
      optional(:description).maybe(:string)
    end
  end
end
