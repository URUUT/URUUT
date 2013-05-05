Crowdfund::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }
  resources :users, :only => [:show]

  get "contacts/new"

  get "contacts/edit"

  get "image/new"

  get "users/profile"

  match "browse/projects" => "pages#index"

   get "projects/save_image"
   post "projects/save_image"
   get "projects/:project_id/sponsors/:id/confirmation" => "sponsors#confirmation", as: "confirmation"
   get "purchase" => "payments#purchase"

   post "projects/submit_project"

   get "projects/stripe_update"

  post "#{Rails.root}/public/images/"

   get "admin/unapproved"
   post "admin/approve"

  resources :admin do
  end

  resources :s3_uploads
  #resources :projects
  namespace :project_admin do
    resources :projects
  end
  resources :donations do
    get "thank_you", :on => :collection
  end
  resources :projects do
    get "add_desc", :on => :collection
    post "add_perk", :on => :collection
    post "get_perk", :on => :collection
    post "update_perk", :on => :collection
    post "delete_perk", :on => :collection
    put "edit", :on => :collection
    resources :sponsors do
      get :get_sponsorship_levels
      get :confirm_sponsor
    end
  end
  
  resources :projects

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
    post "contact_send", :on => :collection
    get "how_it_works", :on => :collection
    get "terms", :on => :collection
    get "about", :on => :collection
    get 'home', :on => :collection
    get "faqs", :on => :collection
    get "thank_you", :on => :collection
    get "privacy", :on => :collection
  end

  root to: "pages#home"

end
