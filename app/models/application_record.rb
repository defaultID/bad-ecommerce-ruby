class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def add_errors(dry_errors)
    Rails.logger.debug dry_errors.inspect

    dry_errors.each do |error|
      self.errors.add error.path.first, error.text
    end
  end
end
