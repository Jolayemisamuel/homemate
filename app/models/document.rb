##
# Copyright (c) Andrew Ying 2017-18.
#
# This file is part of HomeMate.
#
# HomeMate is free software: you can redistribute it and/or modify
# it under the terms of version 3 of the GNU General Public License
# as published by the Free Software Foundation. You must preserve
# all reasonable legal notices and author attributions in this program
# and in the Appropriate Legal Notice displayed by works containing
# this program.
#
# HomeMate is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HomeMate.  If not, see <http://www.gnu.org/licenses/>.
##

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
    dir_name = File.dirname(file_path)

    File.delete(file_path)
    Dir.unlink(dir_name) if Dir.entries(dir_name).count == 0
  end
end
