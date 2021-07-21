# frozen_string_literal: true

xml.instruct!
xml.error do
  xml.type @error.class
  xml.message @error.message
end
