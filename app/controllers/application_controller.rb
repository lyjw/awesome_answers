class ApplicationController < ActionController::Base
  # Authenticates User for all pages except for index
  # skip_before_action :ahthenticate_user!, except [:index]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This method halts the action and redirects (with bang in name due to convention)
  def authenticate_user!
    redirect_to new_session_path, notice: "Please sign in!" unless user_signed_in?
  end

  # A public method that is available in all controllers because every controller inherits from ApplicationController
  def user_signed_in?
    session[:user_id].present?
  end

  # This line makes user_signed_in? method a helper method, which means it will be accessible in the view files as well as controller files
  helper_method :user_signed_in?

  def current_user
    # current_user will be called every time (memoization / lazy loading)
    @current_user ||= User.find session[:user_id] if user_signed_in?
  end
  helper_method :current_user

  def sign_in(user)
    session[:user_id] = user.id
  end

end
