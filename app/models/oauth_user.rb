class OauthUser < ActiveRecord::Base
  has_secure_password
  has_many :oauth_clients
  has_many :oauth_codes
end
