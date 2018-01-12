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

class DocumentTemplate < ApplicationRecord
  store :variables, coder: :json
  attr_accessor :file

  before_save :save_file
  after_destroy :destroy_file

  validates :name, presence: true

  def file_stream
    File::read(file_path)
  end

  private

  def save_file
    destroy_file if file_path.present?

    self.file_type = File.extname(file)
    self.file_path = 'storage/templates/' + SecureRandom.base58(10) + self.file_type

    File.open(file_path, 'wb') do |f|
      f.write(content)
    end
  end

  def destroy_file
    File.delete(file_path)
  end
end
