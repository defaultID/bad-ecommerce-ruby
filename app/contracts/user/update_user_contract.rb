# frozen_string_literal: true

class User
  class UpdateUserContract < BaseContract
    include ImageRule

    option :actor
    option :target

    params do
      optional(:picture).maybe(type?: ActionDispatch::Http::UploadedFile)
      optional(:full_name).maybe(:string)
      optional(:address).maybe(:string)
      optional(:city).maybe(:string)
      optional(:country_code).maybe(:string, size?: 2)
      optional(:locked).value(:bool)
    end

    rule(:country_code) do
      if key? && value.present?
        country = ISO3166::Country.new value

        key.failure('is invalid') unless country.present? && country.valid?
      end
    end

    rule(:locked) do
      key.failure('is not allowed to be set') if key? && !UserPolicy.new(actor, target).update_locked?
    end

    image_rule(:picture)
  end
end
