# Defines the table to be created (but does not automatically create the table)
# To execute, `bin/rake db:migrate`
class CreateQuestions < ActiveRecord::Migration
  def change
    # Create a table named 'questions' (table name is .pluralize(d))
    create_table :questions do |t|
      # t.id field (primary key with autoincrement of type: integer) is added automatically by Rails
      t.string :title
      t.text :body

      # timestamps will add to extra fields: created_at and updated_at of type: datetime
      # They will be automatically set by ActiveRecord
      t.timestamps null: false
    end
  end
end
