class WelcomeController < ApplicationController

  def index
    
  end

  def registration

  end

  def adduser
    email = params[:inputEmail]
    password = params[:inputPassword]
    name = params[:inputName]
    surname = params[:inputSurname]

    ::OauthUser.new(username: email, password: password, first_name: name, last_name: surname)
  end
end
