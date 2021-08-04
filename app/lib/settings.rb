# frozen_string_literal: true

class Settings
  extend Dry::Initializer

  option :language, default: -> { :en }, type: proc(&:to_sym)

  def language=(language)
    @language = language.to_sym
  end
end
