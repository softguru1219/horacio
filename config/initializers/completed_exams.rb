# frozen_string_literal: true

class OldCompletedExams
  def self.create_completed_exam(user, username)
    user_id = user.id

    # Get the exams from table
    exams, noFiche = ScheduleHelper.get_exams(username)

    @completed_exams = User.find(user_id).completed_exams

    conn = ActiveRecord::Base.connection

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
      completes = CompletedExams.get_heures_completes(conn, code_module, noFiche)

      CompletedExams.save_completed_exam(@completed_exams, nom_module, completes, allouees, absences, code_module, ds, user_id)
    end
  end

  # Get the completets from Compilation Heures Modules
  def self.get_heures_completes(conn, code_module, noFiche)
    begin
      c = conn.execute(format('SELECT "HeuresTotales" FROM "horacio_bijouterie_students"."tblCompilationHeuresModules" WHERE "NoFiche"=\'%s\' and "CodeModule"=\'%s\'', noFiche.to_s, code_module.to_s)).first
    rescue StandardError
    end

    completes = c.present? ? c['HeuresTotales'].to_s : nil
  end

  # Save the completeted exams
  def self.save_completed_exam(completed_exams, nom_module, completes, allouees, absences, code_module, date_semaine, user_id)
    current_date = Date.today
    ds = Date.parse(date_semaine)
    unless completed_exams.where('code_module=? and validate_date=?', code_module.to_s, ds).present?
      @completed_exam = CompletedExam.new(module: nom_module, complete: completes, allowees: allouees, absences: absences,
                                          user_id: user_id, code_module: code_module, validate_date: ds)
      @completed_exam.save
    end
  end
end
