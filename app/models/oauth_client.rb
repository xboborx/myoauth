class OauthClient < ActiveRecord::Base
  belongs_to :oauth_user
  has_many :oauth_codes
  has_many :oauth_access_tokens
  has_many :oauth_refresh_tokens
end
