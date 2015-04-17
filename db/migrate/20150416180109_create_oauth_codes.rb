class CreateOauthCodes < ActiveRecord::Migration
  def change
    create_table :oauth_codes do |t|
      t.string :code
      t.belongs_to :oauth_client
      t.belongs_to :oauth_user
      t.timestamp :expires
    end
  end
end