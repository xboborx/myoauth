require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get cars" do
    get :cars
    assert_response :success
  end

  test "should get brands" do
    get :brands
    assert_response :success
  end

end
