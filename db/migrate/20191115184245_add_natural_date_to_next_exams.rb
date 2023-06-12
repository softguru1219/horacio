# frozen_string_literal: true

class AddNaturalDateToNextExams < ActiveRecord::Migration[6.0]
  def change
    add_column :next_exams, :natural_date, :string
  end
end
