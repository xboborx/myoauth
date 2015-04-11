class AddUsersUniqueIndex < ActiveRecord::Migration
  def change
    add_index(:oauth_users, :username, unique: true)
  end
end
