# frozen_string_literal: true

namespace :daily do
  desc 'Examens alert by daily'
  task examens_alert: :environment do
    I18n.locale = :fr
    User.daily_examens_alert
  end
end
