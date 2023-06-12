# frozen_string_literal: true

class NextExams
  def self.create_next_exam(user, username)
    # Get the exams from table
    exams, noFiche = ScheduleHelper.get_exams(username)
    beginning_week_date = ScheduleHelper.beginning_week_date
    current_date = Date.today

    user_id = user.id
    @next_exams = User.find(user_id).next_exams

    exams = []

    conn = ActiveRecord::Base.connection
    results = nil

    reservations = ScheduleHelper.reservations(username)

    reservations.each do |r|
      ds = r['DateXam']

      choix = r['Choix']
      choix = choix.present? ? choix.to_s : nil

      local = r['Local']
      local = local.present? ? local.to_s : nil

      no_transaction = r['NoTransaction']
      no_transaction = no_transaction ? no_transaction.to_s : nil

      code_module, allouees, absences, nom_module = ScheduleHelper.get_heures(conn, noFiche, no_transaction)

      NextExams.save_next_exam(@next_exams, ds, choix, local, current_date, user_id, noFiche, nom_module)
    end
  end

  def self.save_next_exam(next_exams, date_semaine, choix, local, current_date, user_id, noFiche, nom_module)
    ds = Date.parse(date_semaine)

    day_name = I18n.l(ds, format: '%A').capitalize
    day_number = ds.day.to_s
    month_name = I18n.t('date.month_names')[ds.month - 1]
    # month_name = I18n.l(ds, format: '%B')
    natural_date = "#{day_name} le #{day_number} #{month_name}"
    
    unless next_exams.where('date_semaine=? and choix=? and local=?', ds, choix.to_s, local.to_s).present?
      next_exam = NextExam.new(date_semaine: ds, noFiche: noFiche, user_id: user_id, choix: choix,
                               local: local, natural_date: natural_date, examen: nom_module)
      next_exam.save
    end
  end
end
