# frozen_string_literal: true

class User < ApplicationRecord
  # include ActiveModel::Validations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :confirmable

  # devise :timeoutable, :timeout_in => 5.seconds
  validates :username, presence: :true, uniqueness: { case_sensitive: false }

  has_one_attached :avatar

  has_many :schedules
  has_many :next_exams
  has_many :completed_exams

  def self.get_first_class
    @selected_class = User.all.map { |u| u.classes.first }
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def confirmation_required?
    false
  end

  def weekly_schedule(beginning_date)
    schedules.where(first_week_day: beginning_date)&.first
  end

  def active_next_exams(current_date)
    next_exams.where("date_semaine > ?", current_date).order('created_at ASC')
  end
  
  def active_completed_exams(current_date)
    completed_exams.where("validate_date < ?", current_date).uniq {|c| c.code_module}
  end

  def tempa_restant(exams)
    tempa_keys = []
    tempa_vals = []
    
    exams.each do |p|
      tempa_keys.push(p.module)
      tempa_vals.push((p.allowees.to_i - p.complete.to_i).abs)
    end

    [tempa_keys, tempa_vals]
  end


  def absence_vs_presence(exams)
    complete_vals = 0
    absence_vals = 0
    
    exams.each do |p|
      complete_vals += p.complete.to_i
      absence_vals += p.absences.to_i
    end

    abs_com_keys = %w[complete absences]
    abs_com_vals = [complete_vals, absence_vals]
    [abs_com_keys, abs_com_vals]
  end

  def self.get_password(username)
    conn = ActiveRecord::Base.connection
    results = nil

    begin
      results = conn.execute(format('SELECT "DDN" FROM "horacio_bijouterie_students"."tblElèves" WHERE "CodePermanent"=\'%s\'', username.to_s)).first
    rescue StandardError
    end

    password = results['DDN'] if results.present?
  end

  def self.set_access_token
    loop do
      token = SecureRandom.hex(10)
      break token unless User.where(reset_password_token: token).exists?
    end
  end

  # Simulation Daily notification
  def simulation_daily_exmaens_alert(current_user, current_week, current_date)
    title = 'Vous avez un examen demain!'
    period_title = 'aura lieu demain'

    current_week_schedules = Schedule.where(first_week_day: current_week)
    current_week_schedule = current_week_schedules.where(user_id: current_user.id).first

    unless current_week_schedule.nil?
      next_day = I18n.l(current_date.next_day(1), format: '%A').downcase
      notify_day_before = current_user.notify_day_before

      if notify_day_before
        User.send_noticaiton(current_user, next_day, current_week_schedule, title, period_title)
      end
    end
  end

  # Simulation Weekly notification
  def simulation_weekly_examens_alert(current_user, current_week, current_date)
    title = 'Vous avez un examen dans 1 semaine!'
    period_title = 'aura lieu dans une semaine'

    next_week = Date.strptime(current_week, '%m/%d/%Y').next_week.strftime('%m/%d/%Y')
    next_week_schedules = Schedule.where(first_week_day: next_week)
    next_week_schedule = next_week_schedules.where(user_id: current_user.id).first
    
    unless next_week_schedule.nil?
      week_day = I18n.l(current_date.next_day(7), format: '%A').downcase
      notify_week_before = current_user.notify_week_before
      
      if notify_week_before
        User.send_noticaiton(current_user, week_day, next_week_schedule, title, period_title)
      end
    end
  end

  # Daily notification
  def self.daily_examens_alert
    title = 'Vous avez un examen demain!'
    period_title = 'aura lieu demain'

    current_week = ScheduleHelper.beginning_week_date
    current_week_schedules = Schedule.where(first_week_day: current_week)

    current_week_schedules.each do |current_week_schedule|
      next unless current_week_schedule.present?

      user_id = current_week_schedule.user_id
      @user = User.find(user_id)

      next_day = I18n.l(Date.today.next_day(1), format: '%A').downcase
      # next_day = I18n.l(Date.today.days_ago(0), format: '%A').downcase
      notify_day_before = @user.notify_day_before

      if notify_day_before
        send_noticaiton(@user, next_day, current_week_schedule, title, period_title)
      end
    end
  end

  # Weekly notification
  def self.weekly_examens_alert
    title = 'Vous avez un examen dans 1 semaine!'
    period_title = 'aura lieu dans une semaine'

    current_week = ScheduleHelper.beginning_week_date
    next_week = Date.strptime(current_week, '%m/%d/%Y').next_week.strftime('%m/%d/%Y')
    next_week_schedules = Schedule.where(first_week_day: next_week)

    next_week_schedules.each do |next_week_schedule|
      next unless next_week_schedule.present?

      user_id = next_week_schedule.user_id
      @user = User.find(user_id)
      week_day = I18n.l(Date.today.next_day(7), format: '%A').downcase
      notify_week_before = @user.notify_week_before

      if notify_week_before
        send_noticaiton(@user, week_day, next_week_schedule, title, period_title)
      end
    end
  end

  def self.send_noticaiton(current_user, after_day, current_week_schedule, title, period_title)
    after_day_am = "#{after_day}_am"
    after_day_pm = "#{after_day}_pm"

    after_day_am_module = "#{after_day}_am_module"
    after_day_pm_module = "#{after_day}_pm_module"

    am_message = nil
    pm_message = nil

    am_exam_name = current_week_schedule[after_day_am_module].present? ? current_week_schedule[after_day_am_module] : nil
    am_local = current_week_schedule[after_day_am_module].present? ? current_week_schedule[after_day_am] : nil
    am_subject = current_week_schedule[after_day_am_module].present? ? "Votre examen de #{am_exam_name} #{period_title}" : nil
    am_period = current_week_schedule[after_day_am_module].present? ? 'en avant-midi' : nil

    pm_exam_name = current_week_schedule[after_day_pm_module].present? ? current_week_schedule[after_day_pm_module] : nil
    pm_local = current_week_schedule[after_day_pm_module].present? ? current_week_schedule[after_day_pm] : nil
    pm_subject = current_week_schedule[after_day_pm_module].present? ? "Votre examen de #{pm_exam_name} #{period_title}" : nil
    pm_period = current_week_schedule[after_day_pm_module].present? ? 'en après-midi' : nil

    if !am_exam_name.nil? && !pm_exam_name.nil?
      ExamAlertMailer.exam_email(current_user, am_subject, am_exam_name, am_local, title, period_title, am_period).deliver!
      ExamAlertMailer.exam_email(current_user, pm_subject, pm_exam_name, pm_local, title, period_title, pm_period).deliver!
    elsif !am_exam_name.nil?
      ExamAlertMailer.exam_email(current_user, am_subject, am_exam_name, am_local, title, period_title, am_period).deliver!
    elsif !pm_exam_name.nil?
      ExamAlertMailer.exam_email(current_user, pm_subject, pm_exam_name, pm_local, title, period_title, pm_period).deliver!
    end
  end
end
