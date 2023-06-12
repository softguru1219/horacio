class ChangeDateSemainToNextExams < ActiveRecord::Migration[6.0]
  def change
    remove_column :next_exams, :date_semaine
    add_column :next_exams, :date_semaine, :date
  end
end
