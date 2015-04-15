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
end
