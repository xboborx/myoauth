class DataController < ApplicationController
  require 'json'

  def cars_show
    unless verification
      puts "sososos"
    else
      resource = Car.find_by( id: params[:id])
      if resource
        render :json => JSON.pretty_generate(resource.as_json)
      else
        render :json => JSON["error" => "not found"], :status => 404
      end
    end
  end

  def cars_index
    render :json => JSON["error" => "not found"], :status => 404
  end

  def brands_index
    render :json => JSON["error" => "not found"], :status => 404
  end

  def brands_show
    #@resource = Car.find(params[:id])
    resource = Brand.find_by( id: params[:id])
    if resource
      render :json => JSON.pretty_generate(resource.as_json)
    else
      render :json => JSON["error" => "not found"], :status => 404
    end
    #render :json => JSON["error"=>  params[:id]]
  end

  def verification
    headerauth = request.headers["Authorization"]

    if headerauth
      token = headerauth.split(" ")[1]
      bearer = headerauth.split(" ")[0]

      if token && bearer == "Bearer"
        tokenrec = OauthAccessToken.find_by_access_token(token)
        if tokenrec
          if Time.now < tokenrec.expires
            return true
          else
            render :json => JSON["error" => "token expired"], :status => 403
            return false
          end
        else
          render :json => JSON["error" => "invalid token"], :status => 401
          return false
        end
      else
        render :json => JSON["error" => "unauthorized"], :status => 401
        return false
      end
    else
      render :json => JSON["error" => "unauthorized"], :status => 401
      return false
    end
  end

end