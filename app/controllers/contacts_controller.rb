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

class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :can_edit_associable, except: [:index]

  def index
    @current_user = current_user
    @contacts     = current_user.user_association.associable.contacts
  end

  def search
    if current_user.is_landlord?
      results = Contact.where.not(email: nil).all
    elsif current_user.is_tenant?
      landlord = Landlord.first
      results  = landlord.contacts.where.not(email: nil)
    else
      render status: 403
    end

    results = results.search(params[:q]) if params[:q].present?
    render json: paginate(results.order(:id), 15)
  end

  def new
    @contact = current_user.user_association.associable.contacts.new
  end

  def create
    @contact = current_user.user_association.associable.contacts.new(contact_params)

    if @contact.save
      redirect_to contacts_path
    else
      render 'new'
    end
  end

  def edit
    @contact = current_user.user_association.associable.contacts.find(params[:id])
  end

  def update
    @contact = current_user.user_association.associable.contacts.find(params[:id])

    if @contact.update(contact_params)
      redirect_to contacts_path
    else
      render 'edit'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:title, :first_name, :last_name, :role, :email, :phone, :address)
  end

  def paginate(scope, default_per_page = 15)
    collection = scope.page(params[:page]).per((params[:per_page] || default_per_page).to_i)

    current, total, per_page = collection.current_page, collection.total_pages, collection.limit_value

    {
        pagination: {
            current:  current,
            previous: (current > 1 ? (current - 1) : nil),
            next:     (current == total ? nil : (current + 1)),
            per_page: per_page,
            pages:    total,
            count:    collection.total_count
        },
        results:    collection
    }
  end
end