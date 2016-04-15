class AnswersController < ApplicationController
  before_action :authenticate_user!

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
      redirect_to question_path(@question), notice: "Thanks for your answer."
    else
      flash[:alert] = "Answer was not saved."
      # Within the same request cycle, so the path will lead to the same question
      render "/questions/show"
    end
  end

  def destroy
    question = Question.find params[:question_id]
    # Ensure that the answer belongs to question
    answer = question.answers.find params[:id]
    answer.destroy

    redirect_to question_path(question), notice: "Answer deleted."
  end

end
