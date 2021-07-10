# frozen_string_literal: true

module Picture
  class UploadPicture < BaseService
    class RecordNotPersisted < RuntimeError; end

    option :record
    option :path, default: -> { Rails.root.join("public/uploads/#{record.model_name.plural}") }

    private

    def _call(file:)
      raise RecordNotPersisted unless record.persisted?

      dir_path = path.join(record.id.to_s)
      file_path = dir_path.join(file.original_filename)
      File.umask(0o0022)

      FileUtils.mkdir_p dir_path
      FileUtils.mv file.to_path, file_path
      FileUtils.chmod 'u=rw,go=r', file_path
      file.original_filename
    end
  end
end
