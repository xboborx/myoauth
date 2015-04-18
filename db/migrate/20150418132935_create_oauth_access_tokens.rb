class CreateOauthAccessTokens < ActiveRecord::Migration
  def change
    create_table :oauth_access_tokens do |t|
      t.string :access_token
      t.belongs_to :oauth_client
      t.belongs_to :oauth_user
      t.timestamp :expires
    end
  end
end
