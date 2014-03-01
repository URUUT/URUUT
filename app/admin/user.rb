ActiveAdmin.register User do
  actions :all, :except => [:destroy]

  index do
    column :email
    column :first_name
    column :last_name
    column :telephone
    default_actions
  end
end
