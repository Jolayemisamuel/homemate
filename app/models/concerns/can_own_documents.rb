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

module CanOwnDocuments
  extend ActiveSupport::Concern

  included do
    has_many :document_accesses, as: :owner, dependent: :destroy
    has_many :documents, through: :document_accesses

    attr_accessor :current_passphrase, :passphrase, :passphrase_confirmation
    before_save :update_private_key

    validate :check_current_passphrase, if: Proc.new{ |i| i.current_passphrase_present? }
    validates :passphrase, confirmation: true, if: Proc.new{ |i| i.current_passphrase_present? }
    validates :passphrase_validation, presence: true, if: Proc.new{ |i| i.current_passphrase_present? }
  end

  def current_passphrase_present?
    current_passphrase.present?
  end

  private

  def check_current_passphrase
    unless current_passphrase.present? && ApplicationHelper::SecretEncryptor.check_passphrase(private_key, current_passphrase)
      errors.add(:current_passphrase, 'is invalid')
    end
  end

  def update_private_key
    if passphrase.present?
      if private_key.present?
        self.private_key = ApplicationHelper::SecretEncryptor.update_passphrase(private_key, current_passphrase, passphrase)
      else
        generator = ApplicationHelper::SecretEncryptor.generate_key(passphrase)

        self.public_key = generator.fetch(:public)
        self.private_key = generator.fetch(:private)
      end
    end
  end
end