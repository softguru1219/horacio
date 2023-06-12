class AddValidateDateToCompletedExams < ActiveRecord::Migration[6.0]
  def change
    add_column :completed_exams, :validate_date, :date
  end
end
