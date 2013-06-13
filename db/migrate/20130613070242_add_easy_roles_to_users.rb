class AddEasyRolesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :roles, :string, :default => "--- []"
    user = User.create(email: "admin@uruut.com", password: "superAdmin",
                       password_confirmation: "superAdmin", first_name: "Super", last_name: "Admin")
    user.add_role! 'admin'
  end

  def self.down
    remove_column :users, :roles
  end
end
