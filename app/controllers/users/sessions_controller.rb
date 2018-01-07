class Users::SessionsController < Devise::SessionsController
  layout 'auth'

  def create
    super do |user|
      if user.is_a?(User) && user.is_landlord?
        unless Transaction.where(failed: true).where('updated_at > ?', user.last_sign_in_at).empty?
          flash[:danger] = 'There have been failed transaction(s) since your last sign-in. View them '
            + path_to('here', controller: 'transactions', action: 'failed', class: 'alert-link') + '.'
        end

        unless Mandate.where(active: false).where('updated_at > ?', user.last_sign_in_at).empty?
          flash[:danger] = 'A number of mandate(s) have been cancelled since your last sign-in. You may wish to review'
            + 'the status of the tenants ' + path_to('here', tenants_path, class: 'alert-link') + '.'
        end
      end
    end
  end
end
