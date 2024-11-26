Rails.application.routes.draw do
  resources :invitations
  root to: "home#index"
  
  devise_for :users
  resources :user_tandas
  resources :transactions
  resources :tandas
  resources :analytics, only: [:index]
  
  get "/:username" => "users#show", as: :user
end
