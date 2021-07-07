# frozen_string_literal: true

class User
  class UpdateUserContract < BaseContract
    params do
      optional(:full_name).maybe(:string)
      optional(:address).maybe(:string)
      optional(:city).maybe(:string)
      optional(:country_code).maybe(:string, size?: 2)
    end

    rule(:country_code) do
      if key? && value.present?
        country = ISO3166::Country.new value

        key.failure('is invalid') unless country.present? && country.valid?
      end
    end
  end
end
