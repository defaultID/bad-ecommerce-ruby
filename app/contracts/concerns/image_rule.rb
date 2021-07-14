# frozen_string_literal: true

module ImageRule
  extend ActiveSupport::Concern

  class_methods do
    def image_rule(*args)
      rule(*args) do
        key.failure 'is not an image' unless MimeMagic.by_magic(value)&.image?
      end
    end
  end
end
