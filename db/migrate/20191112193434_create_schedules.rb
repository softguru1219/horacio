# frozen_string_literal: true

class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.string :first_week_day
      t.string :lundi_am
      t.string :lundi_pm
      t.string :mardi_am
      t.string :mardi_pm
      t.string :mercredi_am
      t.string :mercredi_pm
      t.string :jeudi_am
      t.string :jeudi_pm
      t.string :vendredi_am
      t.string :vendredi_pm

      t.string :lundi_am_module
      t.string :lundi_pm_module
      t.string :mardi_am_module
      t.string :mardi_pm_module
      t.string :mercredi_am_module
      t.string :mercredi_pm_module
      t.string :jeudi_am_module
      t.string :jeudi_pm_module
      t.string :vendredi_am_module
      t.string :vendredi_pm_module

      t.belongs_to :user
      t.timestamps
    end
  end
end
