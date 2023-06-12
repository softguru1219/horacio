# frozen_string_literal: true

module ApplicationHelper
  def current_year
    current_year = Date.today.year.to_s
  end

  def beginning_week_date(selected_date)
    beginning_date = selected_date.beginning_of_week(:monday)

    day_name = I18n.l(beginning_date, format: '%A').capitalize
    day_number = beginning_date.day.to_s
    month_name = I18n.t('date.month_names')[beginning_date.month - 1].capitalize
    # month_name = I18n.l(ds, format: '%B')
    natural_date = "#{day_number} #{month_name}"
    str_begining_date = beginning_date.strftime('%d/%m/%Y')
    real_current_date = Date.today.strftime('%d/%m/%Y')
    
    [natural_date, str_begining_date, real_current_date]
  end

  def natural_date(week_day, week_index)
    current_date = week_day.present? ? Date.parse(week_day) : Date.today
    selected_date = current_date.beginning_of_week(:monday).next_day(week_index)

    day_name = I18n.l(selected_date, format: '%A').capitalize
    day_number = selected_date.day.to_s
    month_name = I18n.t('date.month_names')[selected_date.month - 1]
    # month_name = I18n.l(ds, format: '%B')
    natural_date = "#{day_name} le #{day_number} #{month_name}"
  end
end
