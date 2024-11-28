Rails.application.routes.draw do
  resources :follow_requests
  root to: "home#index"
  
  devise_for :users
  resources :user_tandas
  resources :transactions
  resources :tandas
  resources :analytics, only: [:index]
  resources :follow_requests, only: [:update, :create, :destroy]
  
  resources :wallets, only: [:create, :show] do
    member do
      post :fund  
      post :transfer
    end
  end

  get "/friends", to: "users#friends", as: :friends
  get "/search_users", to: "users#search", as: :search_users
  get "/:username" => "users#show", as: :user
end
