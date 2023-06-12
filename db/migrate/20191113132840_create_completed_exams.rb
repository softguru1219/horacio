# frozen_string_literal: true

class CreateCompletedExams < ActiveRecord::Migration[6.0]
  def change
    create_table :completed_exams do |t|
      t.string :module
      t.string :complete
      t.string :allowees
      t.string :absences
      t.string :code_module

      t.belongs_to :user
      t.timestamps
    end
  end
end
