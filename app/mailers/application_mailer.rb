class ApplicationMailer < ActionMailer::Base
  default from: %{"Tradescantia" <#{Devise.mailer_sender}>}
  layout 'mailer'
end
