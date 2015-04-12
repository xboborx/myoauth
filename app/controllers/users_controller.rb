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

private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation)
  end

end
