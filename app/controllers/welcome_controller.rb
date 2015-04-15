class WelcomeController < ApplicationController
  def index
    user = OauthUser.find(session[:user_id]) if session[:user_id]
    @clients = user.oauth_clients if session[:user_id]
  end

  def newclient
    if session[:user_id]
      user = OauthUser.find(session[:user_id])
    end
  end

  def createclient
    puts "______________"
      puts params[:clientname]


    user = OauthUser.find(session[:user_id])

    secret = SecureRandom.hex(50)
    client_id = SecureRandom.hex(18)
    user.oauth_clients.create(name: params[:clientname], client_secret: secret, client_id: client_id)


    puts user
    puts "______________"
      redirect_to "/"



  end

  def adduser
    email = params[:inputEmail]
    password = params[:inputPassword]
    name = params[:inputName]
    surname = params[:inputSurname]

    OauthUser.create(username: email, password: password, first_name: name, last_name: surname)
  end
end
