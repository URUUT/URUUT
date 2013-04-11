Crowdfund::Application.routes.draw do

  #devise_for :users

   # match '/auth/:provider/callback', to: 'services#create'

  # get "services/index"
  # 
  # get "services/create"
  # 
  # get "services/destroy"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get "image/new"

  get "users/profile"

  match "browse/projects" => "pages#index"

  # get "pages/discover"
  # get "pages/categories"
  # post "pages/contact"
  # get "pages/contact"
  # get "pages/how_it_works"
  # get "pages/terms"
  # get "pages/about"  
  # get "pages/home"
  # get "pages/faqs"
  # get "pages/thank_you"

  # get "projects/add_desc"
#   get "projects/save_image"
#   post "projects/save_image"
#   
#   post "projects/add_perk"
#   post "projects/get_perk"
#   post "projects/update_perk"
#   post "projects/delete_perk"
#   post "projects/submit_project"

  # get "projects/stripe_update"

  post "#{Rails.root}/public/images/"
  
  # get "admin/unapproved"
  # post "admin/approve"

  resources :admin do
    get 'unapproved', :on => :collection
    post 'admin/approve', :on => :collection
  end
  
  resources :s3_uploads
  resources :projects
  resources :donations
  resources :projects do 
    get "add_desc", :on => :collection
    get "save_image", :on => :collection
    get "stripe_update", :on => :collection
    post "save_image", :on => :collection
    post "add_perk", :on => :collection
    post "get_perk", :on => :collection
    post "update_perk", :on => :collection
    post "delete_perk", :on => :collection
    post "submit_project", :on => :collection
  end
  
  resources :project_steps
  resources :services do
    get "index", :on => :collection
    get "create", :on => :collection
    get "destroy", :on => :collection
  end
  
  resources :pages do
    get "discover", :on => :collection
    get "categories", :on => :collection
    post "contact", :on => :collection
    get "contact", :on => :collection
    get "how_it_works", :on => :collection
    get "terms", :on => :collection
    get "about", :on => :collection
    get 'home', :on => :collection
    get "faqs", :on => :collection
    get "thank_you", :on => :collection
  end

  root to: "pages#home"

end
