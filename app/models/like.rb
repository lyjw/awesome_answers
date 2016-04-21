class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  # Validates the combination of user and question, so every user can only like a question once
  validates :user_id, uniqueness: { scope: :question_id }
end
