# frozen_string_literal: true

class BaseService
  extend Dry::Initializer

  class << self
    def instance(**args)
      @instance ||= new(**args)
    end
  end

  def call(**args)
    args.empty? ? _call : _call(**args)
  end

  private

  def _call(**args)
    fail NotImplementedError
  end

  def invalid(model, result)
    record = model.is_a?(ApplicationRecord) ? model : model.new
    record.attributes = result.to_h
    record.add_errors(result.errors)
    record
  end
end
