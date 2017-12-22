class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@homemate.local'
  layout 'mailer'
end
