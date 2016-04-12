class AddIndexToQuestionsTitle < ActiveRecord::Migration
  def change
    # Indexing will make it faster to search
    add_index :questions, :title
  end
end
