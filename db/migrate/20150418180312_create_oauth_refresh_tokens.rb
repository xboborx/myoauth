class CreateOauthRefreshTokens < ActiveRecord::Migration
  def change
    create_table :oauth_refresh_tokens do |t|
        t.string :refresh_token
        t.belongs_to :oauth_client
        t.belongs_to :oauth_user
    end
  end
end
