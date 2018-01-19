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
  before_action :require_landlord, only: [:new, :create, :destroy]

  def viewer
    @document = URI.unescape(params[:document])
  end

  def show
    associable = current_user.user_association.associable
    @document = associable.documents.find(params[:id])

    if @document.encrypted?
      unless params[:passphrase].present?
        render status: 401, json: {authorised: false}
        return
      end

      access = associable.document_accesses.where(document_id: params[:id]).first
      secret = ApplicationHelper::SecretEncryptor.decrypt(associable.private_key, params[:passphrase], access.encrypted_secret)
    else
      secret = nil
    end

    send_data @document.file_stream(secret),
              filename: @document.name,
              type: @document.file_mime_type
  end

  def new
    @document = Document.new
    @document.attachable_id = params[:id]
    @document.attachable_type = params[:type]
  end

  def create
    @document = Document.new(
      name: document_params[:document_to_attach].original_filename,
      file: document_params[:document_to_attach],
      encrypted: document_params[:encrypted]
    )
    @document.attachable_id = params[:id]
    @document.attachable_type = params[:type]

    @document.document_accesses.new(
        owner: current_user.landlord
    )
    @document.document_accesses.new(
        owner: @document.attachable.tenant
    ) if document_params[:visible]

    if @document.save
      redirect_back fallback_location: root_path
    else
      render 'new'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy!

    redirect_back fallback_location: root_path
  end

  private

  def document_params
    params.require(:document).permit([:document_to_attach, :encrypted, :visible])
  end
end