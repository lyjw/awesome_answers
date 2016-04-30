class AnswersController < ApplicationController
  #
  # include QuestionsAnswersHelper
  # helper_method :user_like

  before_action :authenticate_user!
  before_action :find_question
  before_action :find_and_authorize_answer, only: :destroy

  def create
    # render json: params

    # On submit, a hash will be passed containing the following information:
    #   {
    #     "utf8": "✓",
    #     "authenticity_token": "VLv7pD4hTuVtGRIs89bBLbsODnl/TM6INVNVxlSdteZGa77J4G5ZFPN3doCOucdB5nq0BVaf+qY+dJyt24HTiw==",
    #     "answer": {
    #       "body": "efaewafj alkjflk weajf\r\n"
    #     },
    #     "commit": "Create Answer",
    #     "controller": "answers",
    #     "action": "create",
    #     "question_id": "10"
    #   }

    @question        = Question.find params[:question_id]
    answer_params   = params.require(:answer).permit([:body, :category])
    @answer          = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user

    if @answer.save
      # Relegates the delivery of the email to a background job
      AnswersMailer.notify_question_owner(@answer).deliver_later
      redirect_to question_path(@question), notice: "Thanks for your answer."
    else
      flash[:alert] = "Answer was not saved."
      # Within the same request cycle, so the path will lead to the same question
      render "/questions/show"
    end
  end

  def destroy
    # Always include authorization rules in controller as well as views to ensure users cannot find another entrance
    @answer.destroy
    redirect_to question_path(@question), notice: "Answer deleted."
  end

  private

  def find_question
    @question = Question.find params[:question_id]
  end

  def find_and_authorize_answer
    # Ensure that the answer belongs to question
    @answer = @question.answers.find params[:id]
    redirect_to root_path unless can? :destroy, @answer
    # head will stop the HTTP request and send a response code depending on the symbol (first argument, i.e :unauthorized) that you pass in
    # head :unauthorized unless can? :destroy, @answer
  end

end
