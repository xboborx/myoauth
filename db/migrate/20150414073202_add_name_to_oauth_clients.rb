class AddNameToOauthClients < ActiveRecord::Migration
  def change
    add_column :oauth_clients, :name, :string
  end
end
