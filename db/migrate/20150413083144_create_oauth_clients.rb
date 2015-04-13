class CreateOauthClients < ActiveRecord::Migration
  def change
    create_table :oauth_clients do |t|
      t.string :client_id
      t.string :client_secret
      t.belongs_to :oauth_user, index: true
    end
  end
end
