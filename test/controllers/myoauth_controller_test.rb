require 'test_helper'

class MyoauthControllerTest < ActionController::TestCase
  test "should get auth" do
    get :auth
    assert_response :success
  end

end
