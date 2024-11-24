Rails.application.routes.draw do
  root to: "home#index"
  get "/:username" => "users#show", as: :user

  devise_for :users
  resources :user_tandas
  resources :transactions
  resources :tandas
  resources :analytics, only: [:index]
  
end
