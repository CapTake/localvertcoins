class ApplicationMailer < ActionMailer::Base
  default from: Settings.smtp_config.from
  layout 'mailer'
end
