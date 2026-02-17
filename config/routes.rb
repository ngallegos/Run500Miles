Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :activities

  # Admin routes (not a true RESTful resource)
  get  '/edit_quote',    to: 'admin#edit_quote'
  post '/update_quote',  to: 'admin#update_quote'
  get  '/site_config',   to: 'admin#site_config'
  patch '/update_config', to: 'admin#update_config'
  post '/create_config', to: 'admin#create_config'
  delete '/destroy_config', to: 'admin#destroy_config'
  get  '/config_index',  to: 'admin#config_index'
  get  '/new_config',    to: 'admin#new_config'

  # Named page routes
  get '/contact',      to: 'pages#contact'
  get '/about',        to: 'pages#about'
  get '/help',         to: 'pages#help'
  get '/leaderboards', to: 'pages#leaderboards'

  # Auth shortcuts
  get  '/signup',  to: 'users#signup'
  get  '/statistics', to: 'users#statistics'
  get  '/signin',  to: 'sessions#new'
  get  '/signout', to: 'sessions#destroy'

  root to: 'pages#home'
end
