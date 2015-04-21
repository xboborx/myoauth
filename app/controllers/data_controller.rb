class DataController < ApplicationController
  require 'json'

  def cars_show
    if verification
      resource = Car.find_by( id: params[:id])
      if resource
        render :json => JSON.pretty_generate(resource.as_json)
      else
        render :json => JSON["error" => "not found"], :status => 404
      end
    end
  end

  def cars_index
    if verification
      cars = Car.paginate(:page => params[:page], :per_page => params[:per_page])

      render :json => {
                 :current_page => cars.current_page,
                 :per_page => cars.per_page,
                 :total_entries => cars.total_entries,
                 :entries => cars
      }
    end
  end

  def brands_index
    if verification
      brands = Brand.paginate(:page => params[:page], :per_page => params[:per_page])

      render :json => {
                 :current_page => brands.current_page,
                 :per_page => brands.per_page,
                 :total_entries => brands.total_entries,
                 :entries => brands
             }
    end
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