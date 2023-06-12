# frozen_string_literal: true

class WeeklyShedule
  def self.create_schedule(user, username)
    exams, noFiche = ScheduleHelper.get_exams(username)
    beginning_week_date = ScheduleHelper.beginning_week_date

    user_id = user.id
    @schedule = User.find(user_id).schedules

    exams.each do |s|
      ds = s['DateSemaine']
      # unless Date.parse(ds.to_s) >= Date.parse(ScheduleHelper.str_to_date(beginning_week_date).to_s)
      #   next
      # end

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

      lundi_am_moduleId = s['ModuleLundiAMCodeModule']
      lundi_pm_moduleId = s['ModuleLundiPMCodeModule']

      mardi_am_moduleId = s['ModuleMardiAMCodeModule']
      mardi_pm_moduleId = s['ModuleMardiPMCodeModule']

      mercredi_am_moduleId = s['ModuleMercrediAMCodeModule']
      mercredi_pm_moduleId = s['ModuleMercrediPMCodeModule']

      jeudi_am_moduleId = s['ModuleJeudiAMCodeModule']
      jeudi_pm_moduleId = s['ModuleJeudiPMCodeModule']

      vendredi_am_moduleId = s['ModuleVendrediAMCodeModule']
      vendredi_pm_moduleId = s['ModuleVendrediPMCodeModule']

      WeeklyShedule.save_schedule(@schedule, user_id, date_semaine, lundiAM, lundiPM, mardiAM, mardiPM, mercrediAM, mercrediPM, jeudiAM, jeudiPM,
                                  vendrediAM, vendrediPM, lundi_am_moduleId, lundi_pm_moduleId, mardi_am_moduleId, mardi_pm_moduleId, mercredi_am_moduleId,
                                  mercredi_pm_moduleId, jeudi_am_moduleId, jeudi_pm_moduleId, vendredi_am_moduleId, vendredi_pm_moduleId)
    end
  end

  def self.save_schedule(sc, user_id, beginning_week_date, lundiAM, lundiPM, mardiAM, mardiPM, mercrediAM, mercrediPM, jeudiAM, jeudiPM, vendrediAM, vendrediPM, lundi_am_moduleId, lundi_pm_moduleId, mardi_am_moduleId, mardi_pm_moduleId, mercredi_am_moduleId, mercredi_pm_moduleId, jeudi_am_moduleId, jeudi_pm_moduleId, vendredi_am_moduleId, vendredi_pm_moduleId)
    conn = ActiveRecord::Base.connection

    lundi_am_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', lundi_am_moduleId.to_s)).first
    lundi_am_module = lundi_am_module.present? ? lundi_am_module['NomModule'].capitalize : nil

    lundi_pm_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', lundi_pm_moduleId.to_s)).first
    lundi_pm_module = lundi_pm_module.present? ? lundi_pm_module['NomModule'].capitalize : nil

    mardi_am_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', mardi_am_moduleId.to_s)).first
    mardi_am_module = mardi_am_module.present? ? mardi_am_module['NomModule'].capitalize : nil

    mardi_pm_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', mardi_pm_moduleId.to_s)).first
    mardi_pm_module = mardi_pm_module.present? ? mardi_pm_module['NomModule'].capitalize : nil

    mercredi_am_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', mercredi_am_moduleId.to_s)).first
    mercredi_am_module = mercredi_am_module.present? ? mercredi_am_module['NomModule'].capitalize : nil

    mercredi_pm_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', mercredi_pm_moduleId.to_s)).first
    mercredi_pm_module = mercredi_pm_module.present? ? mercredi_pm_module['NomModule'].capitalize : nil

    jeudi_am_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', jeudi_am_moduleId.to_s)).first
    jeudi_am_module = jeudi_am_module.present? ? jeudi_am_module['NomModule'].capitalize : nil

    jeudi_pm_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', jeudi_pm_moduleId.to_s)).first
    jeudi_pm_module = jeudi_pm_module.present? ? jeudi_pm_module['NomModule'].capitalize : nil

    vendredi_am_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', vendredi_am_moduleId.to_s)).first
    vendredi_am_module = vendredi_am_module.present? ? vendredi_am_module['NomModule'].capitalize : nil

    vendredi_pm_module = conn.execute(format('SELECT "NomModule" FROM "horacio_bijouterie_students"."tblCalculDateFinModuleDétails" WHERE "CodeModule"=\'%s\'', vendredi_pm_moduleId.to_s)).first
    vendredi_pm_module = vendredi_pm_module.present? ? vendredi_pm_module['NomModule'].capitalize : nil

    unless sc.where('first_week_day=?', beginning_week_date.to_s).present?
      begin
        s = Schedule.new(first_week_day: beginning_week_date, lundi_am: lundiAM, lundi_pm: lundiPM, mardi_am: mardiAM, mardi_pm: mardiPM, mercredi_am: mercrediAM,
                         mercredi_pm: mercrediPM, jeudi_am: jeudiAM, jeudi_pm: jeudiPM, vendredi_am: vendrediAM, vendredi_pm: vendrediPM,
                         lundi_am_module: lundi_am_module, lundi_pm_module: lundi_pm_module, mardi_am_module: mardi_am_module, mardi_pm_module: mardi_pm_module,
                         mercredi_am_module: mercredi_am_module, mercredi_pm_module: mercredi_am_module, jeudi_am_module: jeudi_am_module, jeudi_pm_module: jeudi_pm_module,
                         vendredi_am_module: vendredi_am_module, vendredi_pm_module: vendredi_pm_module, user_id: user_id)

        s.save
      rescue Exception => e
        puts e.message.to_s
      end
    end
  end
end
