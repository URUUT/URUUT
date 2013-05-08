class ChangeUserAvatarAddDefault < ActiveRecord::Migration
  change_column :users, :avatar, :string, :default => '/images/default-avatar.png'
end
