# frozen_string_literal: true

set :environment, 'development'
set :output, 'log/cron.log'

# every 1.day, at: '00:01 AM' do # Use any day of the week or :weekend, :weekday
#   rake 'daily:examens_alert'
#   rake 'weekly:examens_alert'
# end

every :day, at: '07:00 AM' do # Use any day of the week or :weekend, :weekday
  rake 'daily:examens_alert'
  rake 'weekly:examens_alert'
end

# whenever --update-crontab
