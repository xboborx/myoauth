class WelcomeController < ApplicationController
  def index
    puts "______________"
    user = OauthUser.find(session[:user_id]) if session[:user_id]
    puts user.oauth_clients
    puts "______________"
  end

  def registration
    
  end

  def adduser
    email = params[:inputEmail]
    password = params[:inputPassword]
    name = params[:inputName]
    surname = params[:inputSurname]

    OauthUser.create(username: email, password: password, first_name: name, last_name: surname)
  end
end
