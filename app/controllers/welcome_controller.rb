class WelcomeController < ApplicationController

  # Defines an 'action'(method) called index for the WelcomeController
  def index
    # render text: "Hello World!"

    # By default (convention), Rails will render:
    # views/welcome/index.html.erb (when receiving a request that has a HTML format)
    # OR render :index
    # OR render "/some_other_folder/some_other_action"

    # Using another format: i.e. /home.text
    # Rails will render a template according to that format ('/home.text')
  end

  def about
    render :about
  end

end
