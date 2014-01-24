require 'sidekiq/web'

Crowdfund::Application.routes.draw do
  # match '/users/auth/:provider/callback', to: 'services#create'

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations",
    :sessions => 'users/sessions',
    :passwords => 'users/passwords'
  }

  resources :users, :only => [:show] do
    get :get_complete_project, on: :collection
    resource  :payment_method
    resources :subscriptions
    resources :memberships do
      get :cancel
    end
  end

  devise_scope :user do
    get "/users/sign_up/step2" => "registrations#step2"
    get "/users/sign_up/confirmation" => "registrations#confirmation"
  end

  get "contacts/new"
  get "contacts/edit"
  get "image/new"
  get "set_new_perk" => "donations#set_new_perk"
  get "users/:user_id/profile" => "users#profile", as: "profile"

  match "browse/projects" => "pages#index", :as => "browse_projects"
  match "search/projects" => "pages#search", :as => "search_projects"

  get "projects/save_image"
  get "update_image" => "projects#update_image"
  get "galleries/save_image"
  get "galleries/delete_photo/:id" => "galleries#destroy", as: "delete_photo_via_get"
  get "galleries/delete_photo_tw_room/:id" => "galleries#delete_media_tw_room", as: "delete_media_tw_room"
  delete "galleries/delete_photo/:id" => "galleries#destroy", as: "delete_photo"
  delete "projects/:id/delete_image" => "projects#delete_image", as: "delete_image"
  get "projects/:project_id/sponsors/:id/confirmation" => "sponsors#confirmation", as: "confirmation"
  get "purchase" => "payments#purchase"
  get "projects/:project_id/sponsors/:sponsor_id/thank_you" => "sponsors#thank_you", as: "thank_you_for_sponsor"

  post "projects/save_image"
  post "galleries/save_image"
  post "galleries/save_photo_tw_room"
  post "share_email_by_sponsor" => "sponsors#share_email"
  post "share_email_by_donor" => "donations#share_email"

  post "projects/submit_project"
  post "update_sponsor_info" => "projects#update_sponsor_info"

  get "projects/stripe_update"
  get "default_perk_donations" => "donations#default_perk"

  post "#{Rails.root}/public/images"

  get "admin/unapproved"
  post "admin/approve"

  get "/skip_sponsor" => "projects#skip_sponsor"

  resources :admin do
    get "deny", :on => :member
  end

  resources :s3_uploads
  namespace :project_admin do
    resources :documents do
      get "delete" => "documents#destroy", :on => :member
    end
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
      get "photos_and_videos"
      get "communication_zone"

      resource :xls, only: [:create]

      collection do
        get "email_based_on_sponsor_level"
        post "send_email"
        post "process_project_update"
      end
    end
  end

  scope '/media' do
    resources :press_releases
    resources :press_coverages
  end

  resources :donations do
    get "thank_you", :on => :collection

    member do
      get "change_perk"
      get "more_donators"
    end
  end
  resources :projects do
    resources :question, :only => [:new, :create]
    collection do
      get :get_complete_project
      get :get_complete_project_public
      get "add_desc"
      get "set_previous_path_for_registration"
      get "set_previous_path_for_registration_perk"
      get "set_perk_to_false"
      get "update_content_assets_tab"
      get "update_sponsorship_content"
      get "update_td_mark"
      post "add_perk"
      post "save_video"
      post "get_perk"
      post "update_perk"
      post "delete_perk"
      put "edit"
      get :download
      get :download_stripe_guide
    end
    get "show_more_image", :on => :member
    resources :sponsors do
      get :get_sponsorship_levels
      get :confirm_sponsor
    end
    resources :transparency_workroom do
      collection do
        get :download_file
      end
    end
    resources :posts do
      collection do
        get :create_post
      end
    end
  end

  resources :projects
  resources :comments

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
    collection do
      get "search_category_or_location"
      get "discover"
      get "categories"
      post "contact"
      get "contact"
      post "contact_send"
      get "how_it_works"
      get "terms"
      get "about"
      get 'home'
      get "faqs"
      get "thank_you"
      get "privacy"
      get "pricing"
      get "funding_sources"
      get "media"
    end
  end

  authenticate :user, lambda { |u| u.role == "admin" } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  root to: "pages#home"

end
