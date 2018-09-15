class ApplicationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper
  default from: 'hr@witmates.com'
  layout 'mailer'
end

