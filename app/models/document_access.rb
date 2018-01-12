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

require_relative '../../lib/homemate/exception'

class DocumentAccess < ApplicationRecord
  belongs_to :document
  belongs_to :owner, polymorphic: true

  attr_writer :secret
  before_save :encrypt_secret

  validates_associated :document, :owner

  private

  def encrypt_secret
    unless document.encrypted?
      return
    end

    if self.secret.empty?
      raise HomeMate::MissingAttribute 'Secret used to encrypt the file is not set'
    end

    self.encrypted_secret = ApplicationHelper::SecretEncryptor.encrypt(owner.public_key, self.secret)
  end
end
