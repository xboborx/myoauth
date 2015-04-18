class OauthUser < ActiveRecord::Base
  has_secure_password
  has_many :oauth_clients
  has_many :oauth_codes
  has_many :oauth_access_tokens
  has_many :oauth_refresh_tokens
end
