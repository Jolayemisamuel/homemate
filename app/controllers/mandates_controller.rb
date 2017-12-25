require 'active_support/core_ext/securerandom'
require 'gocardless_pro'

class MandatesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_tenant

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
        description: Setting.payments.description,
        session_token: token,
        success_redirect_url: complete_new_mandate_url,
        prefilled_customer: {
          given_name: current_user.first_name,
          family_name: current_user.last_name,
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
      access_token: Setting.gocardless.token,
      environment: Setting.gocardless.env
    )
  end
end