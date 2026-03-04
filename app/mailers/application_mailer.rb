class ApplicationMailer < ActionMailer::Base
  DEFAULT_FROM_EMAIL = "pkmiya.my@gmail.com"

  default from: DEFAULT_FROM_EMAIL
  layout "mailer"
end
