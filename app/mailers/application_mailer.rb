# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  if Rails.env.development? || Rails.env.staging?
    default from: 'Horacio <noreply@horacio-staging.jeedee.com>'
  else
    default from: 'Horacio <noreply@horacio-production.jeedee.com>'
  end
  
  layout 'mailer'
end
