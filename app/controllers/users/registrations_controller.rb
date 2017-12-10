class Users::RegistrationsController < Devise::RegistrationsController
  layout 'auth'
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

end
