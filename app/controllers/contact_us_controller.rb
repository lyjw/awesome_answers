class ContactUsController < ApplicationController

  def new
    render :new
  end

  def create
    @name = params[:full_name]
  end
end
