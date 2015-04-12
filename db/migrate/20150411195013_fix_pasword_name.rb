class FixPaswordName < ActiveRecord::Migration
  def change
    rename_column :oauth_users, :password, :password_digest
  end
end
