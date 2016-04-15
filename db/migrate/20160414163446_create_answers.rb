class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      # Creates an integer field called question_id (Rails convention), which is the foreign key for the answers table to the questions table
      # It adds a belongs_to :question relationship to the Answers model
      # index: true automatically creates an index on the question_id field
      # foreign_key: true automatically creates the foreign key constraint
      t.references :question, index: true, foreign_key: true
      t.text :body

      t.timestamps null: false
    end
  end
end
