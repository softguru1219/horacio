class AddExamenToNextExams < ActiveRecord::Migration[6.0]
  def change
    add_column :next_exams, :examen, :string
  end
end
