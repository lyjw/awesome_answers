class QuestionsController < ApplicationController

  # Authenticates that the user is signed in for all actions, except for the index page and show page or (as defined in the ApplicationsController), the user is redirected to the Sign In page
  before_action :authenticate_user!, except: [:index, :show]

  # Defining a method as a 'before_action' will make it so that Rails executes that method before executing that action. This is still within the request cycle.
  # The method can be provided two options: :only or :except, to limit the actions which the 'find_question' method will be executed before.
  before_action :find_question, only: [:show, :edit, :update, :destroy]

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
    # question_params = params.require(:question).permit([:title, :body])
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
  end

  def index
    @questions = Question.all
  end

  def edit
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

  def find_question
    # find method throws an exception if the record does not exist (ActiveRecord::RecordNotFound) - 404
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
