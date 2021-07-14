# frozen_string_literal: true

module Management
  class Message < ApplicationRecord
    belongs_to :user, optional: true
  end
end
