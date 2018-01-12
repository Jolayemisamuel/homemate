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

require 'uri'

class DocumentsController < ApplicationController
  before_action :authenticate_user!

  def viewer
    @document = URI.unescape(params[:document])
  end

  def show
    @document = current_user.documents.find(params[:id])

    if @document.encrypted?
      render status: 401 unless params[:passphrase].present?

      access = current_user.document_accesses.where(document_id: params[:id]).first
      associable = current_user.user_association.associable
      secret = ApplicationHelper::SecretEncryptor.decrypt(associable.private_key, params[:passphrase], access.encrypted_secret)
    else
      secret = nil
    end

    send_data @document.file_stream(secret),
              filename: @document.name,
              type: @document.file_mime_type
  end
end