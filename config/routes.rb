Crowdfund::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get "image/new"

  get "users/profile"

  match "browse/projects" => "pages#index"

  get "pages/discover"

  get "pages/categories"

  post "pages/contact"

  get "pages/contact"

  get "pages/how_it_works"

  get "pages/terms"

  get "pages/about"

  get "projects/add_desc"
  get "projects/save_image"
  post "projects/save_image"
  
  post "projects/add_perk"

  get "projects/stripe_update"

  post "#{Rails.root}/public/images/"

  resources :s3_uploads

  resources :projects

  resources :donations

  resources :projects

  resources :project_steps

  root to: "pages#home"

end
