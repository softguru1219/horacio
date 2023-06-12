# frozen_string_literal: true

namespace :weekly do
  desc 'Examens alert in weekly'
  task examens_alert: :environment do
    I18n.locale = :fr
    User.weekly_examens_alert
  end
end
