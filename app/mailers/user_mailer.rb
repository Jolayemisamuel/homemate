class UserMailer < ApplicationMailer
  def account_created(user, password)
    @user = user
    @password = password

    mail(to: @user.email, subject: 'Welcome to HomeMate')
  end
end
