# frozen_string_literal: true

module ImageHelper
  def upload_image_tag(path, ...)
    if path.present?
      image_tag(path, ...)
    else
      image_pack_tag('No_image_available.svg', ...)
    end
  end
end
