Run500Miles::Application.routes.draw do
  #get "session/new"

  #old stuff
  #get "pages/home"
  #get "pages/profile"
  #get "pages/log_run"
  #get "pages/login"
  #get "pages/contact"  
  #get "pages/about"
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :activities #, :only => [:create, :destroy, :edit]
  resources :admin, :only => [:edit_quote, :site_config, :update_quote, :create_config, :destroy_config, :config_index]
  
  match '/contact', :to => 'pages#contact'
  match '/signup', :to => 'users#signup'
  match '/statistics', :to => 'users#statistics'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/leaderboards', :to => 'pages#leaderboards'
  match '/edit_quote', :to => 'admin#edit_quote'
  match '/site_config', :to => 'admin#site_config'
  match '/update_quote', :to => 'admin#update_quote'
  match '/create_config', :to => 'admin#create_config'
  match '/destroy_config', :to => 'admin#destroy_config'
  match '/config_index', :to => 'admin#config_index'
  match '/new_config', :to => 'admin#new_config'
  match '/update_config', :to => 'admin#update_config'
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "pages#home"
  
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

  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
