Rails.application.routes.draw do
  resources :follow_requests
  root to: "home#index"
  
  devise_for :users
  resources :user_tandas
  resources :transactions
  resources :tandas
  resources :analytics, only: [:index]
  resources :follow_requests
  
  get "/:username" => "users#show", as: :user
end
