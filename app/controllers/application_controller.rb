class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= super && User.includes({user_association: :associable}).find(@current_user.id)
  end

  def require_tenant
    unless current_user.is_tenant?
      flash[:error] = 'You are not authorised to visit this page'
      redirect_back root_path
    end
  end

  def require_landlord
    unless current_user.is_landlord?
      flash[:error] = 'You are not authorised to visit this page'
      redirect_back root_path
    end
  end
end
