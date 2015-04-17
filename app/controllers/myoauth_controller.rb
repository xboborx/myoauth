class MyoauthController < ApplicationController
  def auth
    if session[:user_id]
      user = OauthUser.find(session[:user_id])
      @user_firstname = user.first_name
      @user_lastname = user.last_name

      if params[:client_id] && params[:response_type] == "code" && params[:redirect_uri]
        client = user.oauth_clients.find_by(client_id: params[:client_id])
        if client
          @client_name = client.name
        else
          render :json => JSON["error"=> "invalid_request"], :status => 400
        end
      else
        render :json => JSON["error"=> "invalid_request"], :status => 400
      end


    else
      #redirect_to '/login'
      render :json => JSON["error"=> "unauthorized_client"], :status => 400

    end

  end

  def confirmation
    if params[:commit] == 'Разрешить'
      code = SecureRandom.hex(20)

      coderec = OauthCode.new
      coderec.code = code
      coderec.oauth_user_id = session[:user_id]
      coderec.expires = Time.now + 10.minutes
      client = OauthClient.find_by_client_id(params[:client_id])
      coderec.oauth_client_id = client.id

      #coderec.create_oauth_user()
      coderec.save
      redirect_to "#{params[:redirect_uri]}?code=#{code}"
    else
      redirect_to "#{params[:redirect_uri]}?error=error"
    end
  end

  def token
    code = params[:code]
  end



end
