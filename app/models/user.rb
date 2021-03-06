# frozen_string_literal: true

class User < ApplicationRecord
  attr_reader :password
  attr_accessor :password_confirmation

  has_many :basketed, class_name: 'Basket', dependent: :destroy
  has_many :orders, dependent: :destroy

  def password=(new_password)
    self[:encrypted_password] = Digest::MD5.hexdigest(new_password)
  end

  def country_name
    ISO3166::Country.new(country_code)&.name
  end

  def display_name
    full_name || email
  end

  def admin?
    admin
  end

  def picture_path
    "/uploads/users/#{id}/#{picture}" if picture.present?
  end
end
