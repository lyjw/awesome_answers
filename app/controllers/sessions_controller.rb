class SessionsController < ApplicationController

  before_action :redirect_if_loggedin, only: [:new, :create]

  # There is no Session model. We are not creating any objects here.
  def new
  end

  def create
    # Strong parameters are not necessary as we are not inserting data, just finding
    user = User.find_by_email params[:email]

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed In!"
    else
      flash[:alert] = "Wrong Credentials!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged Out"
  end

  private

  def redirect_if_loggedin
    redirect_to root_path, notice: "Already logged in" if user_signed_in?
  end

end
