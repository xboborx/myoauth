class OauthClient < ActiveRecord::Base
  belongs_to :oauth_user
end
