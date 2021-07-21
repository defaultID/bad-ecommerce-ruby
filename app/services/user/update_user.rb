# frozen_string_literal: true

class User
  class UpdateUser < BaseService
    option :target
    option :actor

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
      User::UpdateUserContract.new(
        actor: actor,
        target: target
      ).call(params)
    end

    def persist(result)
      result = result.to_h
      uploaded_file = result.delete(:picture)

      User.transaction do
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
