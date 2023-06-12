# frozen_string_literal: true

class CompletedExams
  def self.create_completed_exam(user, username)
    user_id = user.id

    # Get the exams from table
    exams, noFiche = ScheduleHelper.get_exams(username)

    @completed_exams = User.find(user_id).completed_exams

    conn = ActiveRecord::Base.connection
    begin
      heureses = conn.execute(format('SELECT * FROM "horacio_bijouterie_students"."tblCompilationHeures" WHERE "NoFiche"=\'%s\'', noFiche.to_s))
    rescue StandardError
    end

    heureses.each do |h|
      ds = h['DateJour']
      ds = ds.present? ? Date.parse(ds) : nil
      nom_module = h['NomModule']
      nom_module = nom_module.present? ? nom_module.capitalize : nil
      allouees = h['HeuresAllouées']
      allouees = allouees.present? ? allouees.to_s : nil
      absences = h['PériodesAbsence']
      absences = absences.present? ? absences.to_s : nil
      code_module = h['CodeModule']

      completes = CompletedExams.get_heures_completes(conn, code_module, noFiche)
      CompletedExams.save_completed_exam(@completed_exams, nom_module, completes, allouees, absences, code_module, user_id, ds)
    end
  end

  def self.get_heures_completes(conn, code_module, noFiche)
    begin
      c = conn.execute(format('SELECT "HeuresTotales" FROM "horacio_bijouterie_students"."tblCompilationHeuresModules" WHERE "NoFiche"=\'%s\' and "CodeModule"=\'%s\'', noFiche.to_s, code_module.to_s)).first
    rescue StandardError
    end

    completes = c.present? ? c['HeuresTotales'].to_s : nil
  end

  def self.save_completed_exam(completed_exams, nom_module, completes, allouees, absences, code_module, user_id, ds)
    unless completed_exams.where('code_module=? and validate_date=?', code_module.to_s, ds).present?
      @completed_exam = CompletedExam.new(module: nom_module, complete: completes, allowees: allouees, absences: absences,
                                          user_id: user_id, code_module: code_module, validate_date: ds)
      @completed_exam.save
    end
  end
end
