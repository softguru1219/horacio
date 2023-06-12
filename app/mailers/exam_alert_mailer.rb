# frozen_string_literal: true

class ExamAlertMailer < ApplicationMailer
  def exam_email(user, subject, exam_name, local, title, period_title, period)
    @user = user
    @local = local
    @title = title
    @exam_name = exam_name
    @title = title
    @period_title = period_title
    @period = period
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    mail(to: @user.email, subject: subject) unless @user.email.nil?
  end
end
