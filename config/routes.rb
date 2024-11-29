Rails.application.routes.draw do
  root to: "home#index"
  
  devise_for :users

  post "/users/:id/create_wallet", to: "users#create_wallet", as: :create_wallet
  post "/users/:id/fund_wallet", to: "users#fund_wallet", as: :fund_wallet
  post "/users/:id/transfer", to: "users#transfer", as: :transfer_wallet

  resources :follow_requests
  resources :user_tandas
  resources :transactions
  resources :tandas
  resources :analytics, only: [:index]
  
 

  get "/friends", to: "users#friends", as: :friends
  get "/search_users", to: "users#search", as: :search_users
  get "/:username" => "users#show", as: :user
end
