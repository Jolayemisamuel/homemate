class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= super && User.includes(:tenant, :landlord).where(id: @current_user.id)
  end
end
