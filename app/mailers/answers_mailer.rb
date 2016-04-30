class AnswersMailer < ApplicationMailer

  def notify_question_owner(answer)
    # Allows us to access @answer inside the view file
    @answer   = answer
    @question = @answer.question
    @owner    = @question.user

    # If a question has no owner, it will not send
    return unless @owner

    mail(to: @owner.email, subject: "You got an answer!")
  end

end
