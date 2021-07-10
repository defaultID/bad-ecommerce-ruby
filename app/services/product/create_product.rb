# frozen_string_literal: true

class Product
  class CreateProduct < BaseService
    private

    def _call(params:)
      result = validate(params.permit!.to_h)

      if result.success?
        persist result
      else
        invalid Product, result
      end
    end

    def validate(params)
      Product::ProductContract.new.call(params)
    end

    def persist(result)
      result = result.to_h
      uploaded_file = result.delete(:picture)

      Product.transaction do
        product = Product.create!(result)
        if uploaded_file
          product.update!(
            picture: Picture::UploadPicture.new(record: product).call(file: uploaded_file)
          )
        end
        product
      end
    end
  end
end
