class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= super && User.includes({user_association: :associable}).find(@current_user.id)
  end

  def current_properties
    if current_user.is_tenant? && (rentable = current_user.tenant.active_tenancy&.rentable)
      collect(rentable.is_a? Room ? rentable.property : rentable)
    elsif current_user.is_landlord?
      current_user.landlord.properties
    else
      collect(Property.none)
    end
  end

  def require_tenant
    unless current_user.is_tenant?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end
  end

  def require_landlord
    unless current_user.is_landlord?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end
  end
end
