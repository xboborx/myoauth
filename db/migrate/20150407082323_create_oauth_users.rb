class CreateOauthUsers < ActiveRecord::Migration
  def change
    create_table :oauth_users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
    end
  end
end
