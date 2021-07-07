# frozen_string_literal: true

module AlertHelper
  # do not use for generating class names from user input
  def alert_class_for(flash_type)
    case flash_type.to_sym
    when :notice
      'alert-info'
    when :alert
      'alert-danger'
    else
      "alert-#{flash_type}"
    end
  end
end
