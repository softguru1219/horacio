# frozen_string_literal: true

class AddClassesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :classes, :text, array: true, default: []
  end
end
