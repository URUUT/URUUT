ActiveAdmin.register User do
  index do
    column :email
    column :first_name
    column :last_name
    column :telephone
    default_actions
  end
end
