class UsersController < ApplicationController

  def new
    # cookies[:abc] = "Hello"
    # cookies[:xyz] = "This"
    # Entire session object is put into 'awesome_answer_session' under Resources (when inspected) as a big encrypted string
    # session[:abc] = "Hello"
    # session[:xyz] = "Goodbye"
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    @user = User.new user_params

    if @user.save
      # Logs the user in by setting the session :user_id to the user's id in our database. This identifies the user that is logged in by their id.
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created!"
    else
      flash[:alert] = "Account was not created!"
      render :new
    end
  end
end
