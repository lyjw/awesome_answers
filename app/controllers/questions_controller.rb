class QuestionsController < ApplicationController

  # include QuestionsAnswersHelper
  # helper_method :user_like

  # Authenticates that the user is signed in for all actions, except for the index page and show page or (as defined in the ApplicationsController), the user is redirected to the Sign In page
  before_action :authenticate_user!, except: [:index, :show]

  # Defining a method as a 'before_action' will make it so that Rails executes that method before executing that action. This is still within the request cycle.
  # The method can be provided two options: :only or :except, to limit the actions which the 'find_question' method will be executed before.
  # before_action :find_question, only: [:show, :update, :edit, :destroy]

  before_action :find_question, only: [:edit, :update, :destroy, :show]
  before_action :authorize_question, only: [:edit, :update, :destroy]

  def new
    # Define a new 'Question' object in order to generate a form in Rails
    @question = Question.new
  end

  def create
    # Method 1
    # @question = Question.new
    # @question.title = params[:question][:title]
    # @question.body = params[:question][:body]
    # @question.save!

    # Method 2
    # @question = Question.create({title: params[:question][:title],
    #                              body: params[:question][:body]})

    # Method 3
    # "question"=>{"title"=>"Question 1", "body"=>"Hello World"}
    # @question = Question.create(params[:question])
    # This will throw a: ActiveMethod::ForbiddenAttributeError exception

    # Method 4
    # We use the Strong Parameters feature of Rails
    # Require a key called :question (in params) and permit only the keys of title and body (explicit)
    question_params = params.require(:question).permit([:title, :body])
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:notice] = "Question created!"
      # redirect_to question_path({id: @question.id})
      redirect_to question_path(@question)
    else
      flash[:alert] = "Question didn't save!"
      # Renders the :new template. Default action is to render :create
      render :new
    end
  end

  # We receive a request, such as : GET /questions/56
  # params[:id] will be '56' (Automatically converts .to_i)
  def show
    @answer = Answer.new
    @answers = @question.answers.all

    # Supports three different formats (i.e /home(:.format))
    respond_to do |format|
      format.html { render }
      # Processing by QuestionsController#show as JSON
      format.json { render json: @question.to_json }
      format.xml  { render xml: @question.to_xml }
    end
  end

  def index
    @questions = Question.all
  end

  def edit
    # Only allows the current user to edit questions that were created by them
    # @question = current_user.questions.find params[:id]
  end

  def update
    if @question.update question_params
      # Flash messages can be set either directly using: flash[:notice] = "...". You can also pass notice or alert options to the 'redirect_to" method.
      redirect_to question_path(@question), notice: "Question updated!"
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "Question deleted!"
  end

  private

  def authorize_question
    redirect_to root_path unless can? :crud, @question
    # @question = current_user.questions.find params[:id]
  end

  def find_question
    # find method throws an exception if the record does not exist (ActiveRecord::RecordNotFound) - 404
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit( :title,
                                      :body,
                                      :category_id,
                                      tag_ids: [])
  end

  def user_like
    @user_like ||= @question.liked_by(current_user)
  end
  helper_method :user_like

end
