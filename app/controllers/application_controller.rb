class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= super && User.includes(:tenants, :landlords).where(id: @current_user.id)
  end
end
