class User < ApplicationRecord
  attr_reader :password
  attr_accessor :password_confirmation

  def password=(new_password)
    write_attribute(:encrypted_password, Digest::MD5.hexdigest(new_password))
  end
end
