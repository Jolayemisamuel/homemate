require 'active_support/core_ext/securerandom'

class Document < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  attr_accessor :file

  before_save :file_encryptor
  after_destroy :file_delete

  def file_stream
    if encrypted
      ApplicationHelper::Encryptor.decrypt(File.read(file_path), iv)
    else
      File::read(file_path)
    end
  end

  def file_mime_type
    Rack::Mime.mime_type(file_type)
  end

  private

  def file_encryptor
    file_delete if file_path.present?

    self.file_type = File.extname(file)
    self.file_path = 'storage/' + SecureRandom.base58(10)

    Dir.mkdir(file_path)

    self.file_path += '/' + SecureRandom.base58(10) + file_type

    content = file.read
    if encrypted
      encryptor = ApplicationHelper::Encryptor.encrypt(content)
      self.iv = encryptor[iv]
      content = encryptor[file]
    end

    File.open(self.file_path, 'wb') do |f|
      f.write(content)
    end
  end

  def file_delete
    File.delete(file_path) if Pathname(file_path).exist?

    self.file_path = null
    self.file_type = null
  end
end
