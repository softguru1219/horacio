# frozen_string_literal: true

class CreateNextExams < ActiveRecord::Migration[6.0]
  def change
    create_table :next_exams do |t|
      t.string :date_semaine
      t.string :noFiche
      t.string :choix
      t.string :local

      t.belongs_to :user
      t.timestamps
    end
  end
end
