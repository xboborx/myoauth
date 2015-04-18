class OauthRefreshToken < ActiveRecord::Base
  belongs_to :oauth_user
  belongs_to :oauth_code
end