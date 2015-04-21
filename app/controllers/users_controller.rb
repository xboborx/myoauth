class UsersController < ApplicationController

  def new
  end

  def create
    user = OauthUser.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  def me

    if tokenparam = request.headers["Authorization"].split(' ')[1]
      if tokenrecord = OauthAccessToken.find_by_access_token(tokenparam)
        if tokenrecord.expires > Time.now
          user = OauthUser.joins(:oauth_access_tokens).where(oauth_access_tokens:{access_token: tokenparam}).first
          if user
            render :json => JSON["first_name"=> user.first_name, "last_name"=>user.last_name, "email"=>user.username]
          else
            render :json => JSON["error"=> "invalid_token"], :status => 400
          end
        else
          render :json => JSON["error"=> "invalid_token","error_description"=>"The access token expired"], :status => 400
          tokenrecord.destroy
          end
      else
        render :json => JSON["error"=> "invalid_token"], :status => 400
      end
    else
      render :json => JSON["error"=> "invalid_token"], :status => 400
    end


  end


private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation)
  end



end
