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
require 'gocardless_pro'

class MandatesController < ApplicationController
  before_action :authenticate_user!, :require_tenant

  def new
    if current_user.tenant.mandates.present?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end
  end

  def create
    if current_user.tenant.mandates.present?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end

    client = gocardless_client

    token = SecureRandom.base58(12)
    redirect = client.redirect_flows.create(
      params: {
        description: Settings.payment.description,
        session_token: token,
        success_redirect_url: complete_new_mandate_url,
        prefilled_customer: {
          given_name: current_user.contact.first_name,
          family_name: current_user.contact.last_name,
          email: current_user.email
        }
      }
    )
    session[:gocardless_token] = token

    redirect_to redirect.redirect_url
  end

  def complete
    unless params[:redirect_flow_id] && session[:gocardless_token]
      abort
    end

    if current_user.tenant.mandates.present?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end

    client = self.gocardless_client

    begin
      @flow = client.redirect_flows.complete(
        params[:redirect_flow_id],
        params: {
          session_token: session[:gocardless_token]
        }
      )
    rescue GoCardlessPro::ValidationError
      return render 'error'
    end

    current_user.user_association.associable.mandates.create(
      method: @flow.scheme,
      reference: @flow.id,
      active: true
    )
  end

  private

  def gocardless_client
    GoCardlessPro::Client.new(
      access_token: Settings.gocardless.token,
      environment: Settings.gocardless.env
    )
  end
end