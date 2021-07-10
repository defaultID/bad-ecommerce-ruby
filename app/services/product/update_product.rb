# frozen_string_literal: true

class Product
  class UpdateProduct < BaseService
    option :target

    private

    def _call(params:)
      result = validate(params.permit!.to_h)

      if result.success?
        persist result
      else
        invalid target, result
      end
    end

    def validate(params)
      Product::ProductContract.new.call(params)
    end

    def persist(result)
      result = result.to_h
      uploaded_file = result.delete(:picture)

      Product.transaction do
        target.update! result
        if uploaded_file
          target.update!(
            picture: Picture::UploadPicture.new(record: target).call(file: uploaded_file)
          )
        end
        target
      end
    end
  end
end
