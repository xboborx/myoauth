class OauthClient < ActiveRecord::Base
  belongs_to :oauth_user
  has_many :oauth_codes
end
