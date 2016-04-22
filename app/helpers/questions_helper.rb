module QuestionsHelper

  def user_like
    @user_like ||= @question.liked_by(current_user)
  end

end
