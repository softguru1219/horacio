# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :validate_signin
  before_action :authenticate_user!

  def index
    selected_date = params[:selected_date]
    @current_date = selected_date.present? ? Date.parse(selected_date) : Date.today
    @convert_date = @current_date.strftime('%d/%m/%Y')

    if params[:forward].present?
      @current_date = @current_date.next_day(7)
    elsif params[:previous].present?
      @current_date = @current_date.days_ago(6)
    end

    beginning_date = @current_date.beginning_of_week(:monday).strftime('%m/%d/%Y')

    # Weekly schedule
    @schedule = current_user.weekly_schedule beginning_date

    # Next exams
    @next_exams = current_user.active_next_exams @current_date
    
    # Completed exams
    @completed_exams = current_user.active_completed_exams @current_date

    # Values of graph
    @tempa_keys, @tempa_vals = current_user.tempa_restant @completed_exams
    @abs_com_keys, @abs_com_vals = current_user.absence_vs_presence @completed_exams
    
    if params[:email_checking].present?
      current_user.simulation_daily_exmaens_alert current_user, beginning_date, @current_date
      current_user.simulation_weekly_examens_alert current_user, beginning_date, @current_date
    end
  end
end
