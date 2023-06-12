# frozen_string_literal: true

class OldNextExams
  def self.create_next_exam(user, username)
    # Get the exams from table
    exams, noFiche = ScheduleHelper.get_exams(username)
    beginning_week_date = ScheduleHelper.beginning_week_date
    current_date = Date.today

    user_id = user.id
    @next_exams = User.find(user_id).next_exams

    exams.each do |s|
      ds = s['DateSemaine']
      unless Date.parse(ds.to_s) >= Date.parse(ScheduleHelper.str_to_date(beginning_week_date).to_s)
        next
      end

      date_semaine = ds.strftime('%m/%d/%Y')
      lundiAM = s['LundiAM']
      lundiPM = s['LundiPM']
      mardiAM = s['MardiAM']
      mardiPM = s['MardiPM']
      mercrediAM = s['MercrediAM']
      mercrediPM = s['MercrediPM']
      jeudiAM = s['JeudiAM']
      jeudiPM = s['JeudiPM']
      vendrediAM = s['VendrediAM']
      vendrediPM = s['VendrediPM']

      NextExams.save_next_exam(@next_exams, lundiAM, lundiPM, ds, week_day = 'lundi', current_date, noFiche, user_id)
      NextExams.save_next_exam(@next_exams, mardiAM, mardiPM, ds, week_day = 'mardi', current_date, noFiche, user_id)
      NextExams.save_next_exam(@next_exams, mercrediAM, mercrediPM, ds, week_day = 'mercredi', current_date, noFiche, user_id)
      NextExams.save_next_exam(@next_exams, jeudiAM, jeudiPM, ds, week_day = 'jeudi', current_date, noFiche, user_id)
      NextExams.save_next_exam(@next_exams, vendrediAM, vendrediPM, ds, week_day = 'vendredi', current_date, noFiche, user_id)
    end
  end

  def self.save_next_exam(next_exams, amPlace, pmPlace, ds, week_day, current_date, noFiche, user_id)
    if week_day == 'mardi'
      ds = ds.next_day(1)
    elsif week_day == 'mercredi'
      ds = ds.next_day(2)
    elsif week_day == 'jeudi'
      ds = ds.next_day(3)
    elsif week_day == 'vendredi'
      ds = ds.next_day(4)
    end
    date_semaine = ds.strftime('%m/%d/%Y')

    day_name = I18n.l(ds, format: '%A').capitalize
    day_number = ds.day.to_s
    month_name = I18n.t('date.month_names')[ds.month - 1]
    # month_name = I18n.l(ds, format: '%B')
    natural_date = "#{day_name} le #{day_number} #{month_name}"

    if (Date.parse(ds.to_s) > current_date) && amPlace.present?
      choix = 'AM'
      unless next_exams.where('date_semaine=? and choix=? and local=?', date_semaine.to_s, choix.to_s, amPlace.to_s).present?
        next_exam = NextExam.new(date_semaine: date_semaine, noFiche: noFiche, user_id: user_id, choix: choix,
                                 local: amPlace.to_s, natural_date: natural_date)
        next_exam.save
      end
    end

    if (Date.parse(ds.to_s) > current_date) && pmPlace.present?
      choix = 'PM'
      unless next_exams.where('date_semaine=? and choix=? and local=?', date_semaine.to_s, choix.to_s, pmPlace.to_s).present?
        next_exam = NextExam.new(date_semaine: date_semaine, noFiche: noFiche, user_id: user_id, choix: choix,
                                 local: amPlace.to_s, natural_date: natural_date)
        next_exam.save
      end
    end
  end
end
