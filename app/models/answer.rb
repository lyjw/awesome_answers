class Answer < ActiveRecord::Base
  # This allows us to fetch the question for the given answer by running:
  # a = Answer.find(14)
  # q = a.question

  # belongs_to assumes that the 'answers' table has a foreign_key called question_id (Rails convention)
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def user_full_name
    user ? user.full_name : "Anonymous"
  end

end
