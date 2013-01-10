Crowdfund::Application.routes.draw do
  
  devise_for :users
  devise_for :sponsors, :controllers => { :dashboard => "sponsors/dashboard" }
  
  match '/auth/:provider/callback', :to => 'authentications#create'
  
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
 
  get "projects/step1"
  post "projects/step1"
  
  get "projects/step2"
  post "projects/step2"
  put "projects/step2"
  
  get "projects/step3"
  post "projects/step3"
  put "projects/step3"
  
  get "projects/step4"
  post "projects/step4"
  put "projects/step4"
  
  get "projects/stripe_update"

  post "#{Rails.root}/public/images/"

  resources :s3_uploads

  resources :projects

  resources :donations
  
  resources :projects

  root to: "pages#home"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
