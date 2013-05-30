Crowdfund::Application.routes.draw do
  # match '/users/auth/:provider/callback', to: 'services#create'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations"}
  # devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users, :only => [:show]

  get "contacts/new"

  get "contacts/edit"

  #devise_for :users

  # get "services/index"
  #
  # get "services/create"
  #
  # get "services/destroy"

  get "image/new"

  get "users/profile"

  match "browse/projects" => "pages#index", :as => "browse_projects"
  match "search/projects" => "pages#search", :as => "search_projects"
  
   get "projects/save_image"
   post "projects/save_image"
   get "projects/:project_id/sponsors/:id/confirmation" => "sponsors#confirmation", as: "confirmation"
   get "purchase" => "payments#purchase"
   get "projects/:project_id/sponsors/:sponsor_id/thank_you" => "sponsors#thank_you", as: "thank_you_for_sponsor"

   post "share_email_by_sponsor" => "sponsors#share_email"

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
    resources :projects do
      get "messages"
      get "overview"
      get "manage"
      get "detail"
      get "visual"
      get "cover_photo_and_gallery"
      get "post_to_social_media"
      get "emails_page"

      collection do
        get "email_based_on_sponsor_level"
        post "send_email"
      end
    end
  end
  resources :donations do
    get "thank_you", :on => :collection
    get "change_perk", :on => :member
  end
  resources :projects do
    get "add_desc", :on => :collection
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

  root to: "pages#home"

end
