class AddViewCountToQuestions < ActiveRecord::Migration
  def change
    # This migration adds a column named 'view_count' to the 'questions' table
    # The type of the column is integer
    add_column :questions, :view_count, :integer, after: :question_body#, default: 0, null: false
  end
end
