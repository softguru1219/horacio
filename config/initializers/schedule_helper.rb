# frozen_string_literal: true

class ScheduleHelper
  def self.str_to_date(str)
    d = Date.strptime(str, '%m/%d/%Y')
  end

  def self.get_exams(username)
    conn = ActiveRecord::Base.connection
    results = nil

    exams = []

    begin
      results = conn.execute(format('SELECT "NoFiche" FROM "horacio_bijouterie_students"."tblElèves" WHERE "CodePermanent"=\'%s\'', username.to_s)).first
    rescue StandardError
    end

    noFiche = results.present? ? results['NoFiche'].to_s : nil

    begin
      exams = conn.execute(format('SELECT * FROM "horacio_bijouterie_students"."tblHoraireElèves" WHERE "NoFiche"=\'%s\'', noFiche.to_s))
    rescue StandardError
    end

    [exams, noFiche]
  end

  def self.beginning_week_date
    Date.today.beginning_of_week(:monday).strftime('%m/%d/%Y')
  end

  def self.reservations(username)
    exams, noFiche = ScheduleHelper.get_exams(username)
    beginning_week_date = ScheduleHelper.beginning_week_date
    current_date = Date.today

    conn = ActiveRecord::Base.connection
    results = nil
    reservations = []

    begin
      reservations = conn.execute(format('SELECT * FROM "horacio_bijouterie_students"."tblRéservationsDétails" WHERE "NoFiche"=\'%s\'', noFiche.to_s))
    rescue StandardError
    end

    reservations
  end

  # Get the allouees, absences from Compilation Heures
  def self.get_heures(conn, noFiche, no_transaction)
    heureses = nil

    c = conn.execute(format('SELECT "CodeModule" FROM "horacio_bijouterie_students"."tblRéservations" WHERE "NoFiche"=\'%s\' and "NoTransaction"=\'%s\'', noFiche.to_s, no_transaction.to_s)).first
    code_module = c.present? ? c['CodeModule'].to_s : nil

    begin
      heureses = conn.execute(format('SELECT * FROM "horacio_bijouterie_students"."tblCompilationHeures" WHERE "NoFiche"=\'%s\' and "CodeModule"=\'%s\'', noFiche.to_s, code_module.to_s)).first
    rescue StandardError
    end

    allouees = heureses.present? ? heureses['HeuresAllouées'].to_s : nil
    absences = heureses.present? ? heureses['PériodesAbsence'].to_s : nil
    nom_module = heureses.present? ? heureses['NomModule'].capitalize : nil

    [code_module, allouees, absences, nom_module]
  end

end
