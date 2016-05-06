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
    answer_params   = params.require(:answer).permit([:body])
    @answer          = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user

    # 'format' is the part you see at the end of the URL (by default, .html)
    respond_to do |format|
      if @answer.save
        # Relegates the delivery of the email to a background job
        AnswersMailer.notify_question_owner(@answer).deliver_later
        # If the format is HTML, then redirect
        format.html { redirect_to question_path(@question), notice: "Thanks for your answer."}
        # format.js { render js: "alert('success');"}
        format.js { render :create_success }
      else
        flash[:alert] = "Answer was not saved."
        # Within the same request cycle, so the path will lead to the same question
        format.html { render "/questions/show" }
        format.js { render :create_failure }
      end
    end

  end

  def destroy
    # Always include authorization rules in controller as well as views to ensure users cannot find another entrance
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to question_path(@question), notice: "Answer deleted." }
      format.js { render } # renders destroy.js.erb by default
    end
  end

  def edit
    @answer = Answer.find params[:id]
  end

  def update
    @answer = Answer.find params[:id]
    answer_params = params.require(:answer).permit([:body])

    if @answer.update answer_params
      respond_to do |format|
        format.js { render :update_success }
      end
    else
      respond_to do |format|
        format.js { render :update_failure }
      end
    end

    # Render create_success / create_failure?
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
