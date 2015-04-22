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
      redirect_to "#{params[:redirect_uri]}?error=access_denied"
    end
  end

  def token
    code = params[:code]
    client_id = params[:client_id]
    client_secret = params[:client_secret]

    if params[:grant_type] == "grant_type"
      client=OauthClient.find_by(client_id: client_id)
      if client
        if client.client_secret == client_secret
          #
          coderec = OauthCode.find_by(code: code)

          if coderec
            if coderec.oauth_client_id == client.id
              if coderec.expires > Time.now

                ##create new token
                accesstkn = addAccessToken(client.id, coderec.oauth_user_id)
                refreshtkn = addRefreshToken(client.id, coderec.oauth_user_id)
                render :json => JSON["access_token"=> accesstkn, "expires_in" => "120", "token_type"=>"Bearer", "refresh_token"=>refreshtkn]
              else
                render :json => JSON["error"=> "invalid_request", "error_description" => "code expired"], :status => 400
              end
              coderec.destroy
            else
              render :json => JSON["error"=> "invalid_request"], :status => 400
            end
          else
            render :json => JSON["error"=> "invalid_request", "error_description" => "code is invalid"], :status => 400
          end
          #
        else
          render :json => JSON["error"=> "invalid_request", "error_description" => "client_secret is invalid"], :status => 400
        end
      else
        render :json => JSON["error"=> "invalid_request", "error_description" => "client_id is invalid"], :status => 400
      end
    else
      render :json => JSON["error"=> "invalid_request"], :status => 400
    end


  end

  def refresh
    if params[:grant_type] == 'refresh_token'
      if refreshrecord = OauthRefreshToken.find_by_refresh_token(params[:refresh_token])
        #create new access
        accesstoken = OauthAccessToken.new
        accesstoken.access_token = SecureRandom.hex(20)
        accesstoken.oauth_client_id = refreshrecord.oauth_client_id
        accesstoken.oauth_user_id = refreshrecord.oauth_user_id
        accesstoken.expires = Time.now + 2.minutes
        accesstoken.save
        #create new refresh
        refreshtoken = OauthRefreshToken.new
        refreshtoken.refresh_token = SecureRandom.hex(20)
        refreshtoken.oauth_client_id = refreshrecord.oauth_client_id
        refreshtoken.oauth_user_id = refreshrecord.oauth_user_id
        refreshtoken.save

        refreshrecord.destroy

        render :json => JSON["access_token"=> accesstoken.access_token, "expires_in" => "120", "token_type"=>"Bearer", "refresh_token"=>refreshtoken.refresh_token]
      else
        render :json => JSON["error"=> "invalid_request", "error_description" => "Invalid refresh token"], :status => 400

      end
    else
      render :json => JSON["error"=> "invalid_request", "error_description" => "The request includes an invalid parameter value or includes an invalid parameter value"], :status => 400
    end
  end

  def addAccessToken(oauth_client_id,oauth_user_id)
    tkn = SecureRandom.hex(20)
    tokenrec = OauthAccessToken.new
    tokenrec.access_token = tkn
    tokenrec.oauth_client_id = oauth_client_id
    tokenrec.oauth_user_id = oauth_user_id
    tokenrec.expires = Time.now + 2.minutes
    tokenrec.save
    return tkn
  end

  def addRefreshToken(oauth_client_id,oauth_user_id)
    tkn = SecureRandom.hex(20)
    tokenrec = OauthRefreshToken.new
    tokenrec.refresh_token = tkn
    tokenrec.oauth_client_id = oauth_client_id
    tokenrec.oauth_user_id = oauth_user_id
    tokenrec.save
    return tkn
  end




end
