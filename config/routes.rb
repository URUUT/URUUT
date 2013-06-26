require 'sidekiq/web'

Crowdfund::Application.routes.draw do
  # match '/users/auth/:provider/callback', to: 'services#create'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations"}
  # devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users, :only => [:show] do
    get :get_complete_project, on: :collection
  end

  get "contacts/new"

  get "contacts/edit"

  #devise_for :users

  # get "services/index"
  #
  # get "services/create"
  #
  # get "services/destroy"

  get "image/new"

  get "set_new_perk" => "donations#set_new_perk"

  # get "users/profile"
  get "users/:user_id/profile" => "users#profile", as: "profile"

  match "browse/projects" => "pages#index", :as => "browse_projects"
  match "search/projects" => "pages#search", :as => "search_projects"

   get "projects/save_image"
   post "projects/save_image"
   get "update_image" => "projects#update_image"
   post "galleries/save_image"
   get "galleries/save_image"
   delete "galleries/delete_photo/:id" => "galleries#destroy", as: "delete_photo"
   delete "projects/:id/delete_image" => "projects#delete_image", as: "delete_image"
   get "projects/:project_id/sponsors/:id/confirmation" => "sponsors#confirmation", as: "confirmation"
   get "purchase" => "payments#purchase"
   get "projects/:project_id/sponsors/:sponsor_id/thank_you" => "sponsors#thank_you", as: "thank_you_for_sponsor"

   post "share_email_by_sponsor" => "sponsors#share_email"

   post "projects/submit_project"
   post "update_sponsor_info" => "projects#update_sponsor_info"

   get "projects/stripe_update"
   get "default_perk_donations" => "donations#default_perk"

  post "#{Rails.root}/public/images/"

   get "admin/unapproved"
   post "admin/approve"

   get "/skip_sponsor" => "projects#skip_sponsor"

  resources :admin do
    get "deny", :on => :member
  end

  resources :s3_uploads
  #resources :projects
  namespace :project_admin do
    resources :projects do
      get "messages"
      get "overview"
      get "manage"
      get "detail"
      get "visual"
      get "cover_photo_and_gallery"
      get "post_to_social_media"
      get "emails_page"
      get "project_founder"
      get "project_update"

      collection do
        get "email_based_on_sponsor_level"
        post "send_email"
        post "process_project_update"
      end
    end
  end
  resources :donations do
    get "thank_you", :on => :collection
    get "change_perk", :on => :member
    get "more_donators", :on => :member
  end
  resources :projects do
    get :get_complete_project, on: :collection
    get :get_complete_project_public, on: :collection
    get "add_desc", :on => :collection
    get "set_previous_path_for_registration", :on => :collection
    get "set_previous_path_for_registration_perk", :on => :collection
    get "set_perk_to_false", :on => :collection
    get "update_content_assets_tab", :on => :collection
    get "update_td_mark", :on => :collection
    post "add_perk", :on => :collection
    post "save_video", :on => :collection
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
  resources :donation_steps

  resources :services, :only => [:index, :create, :destroy]
  resources :newsletters, :only => [:create]
  #resources :services do
  #  get "index", :on => :collection
  #  get "create", :on => :collection
  #  get "destroy", :on => :collection
  #end

  resources :pages do
    get "search_category_or_location", :on => :collection
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
    get "funding_sources", :on => :collection
  end
  
  mount Sidekiq::Web => '/sidekiq'

  root to: "pages#home"

end
