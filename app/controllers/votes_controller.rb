class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vote = Vote.new(is_up:    params[:vote][:is_up],
                    question: question,
                    user:     current_user)

    if vote.save
      redirect_to question_path(question), notice: "Question upvoted"
    else
      redirect_to question_path(question), alert: "Already upvoted."
    end


  end

  def update
    if vote.update(params.require(:vote).permit(:is_up))
      redirect_to question, notice: "Vote changed!"
    else
      redirect_to question, notice: "Vote was not changed."
    end
  end

  def destroy
    vote.destroy
    redirect_to question, notice: "Vote Undone!"
  end

  private

  def question
    @question ||= Question.find params[:question_id]
  end

  def vote
    @vote ||= current_user.votes.find params[:id]
  end


end
