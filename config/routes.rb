Rails.application.routes.draw do
  root to: 'orders#index'
  devise_for :users
  resources :orders, only: [:index]
end
