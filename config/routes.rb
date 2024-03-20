Rails.application.routes.draw do
  root to: 'orders#index'
  devise_for :users
  resources :orders
  get 'orders/:confirmation_token/view', to: 'orders#view_order', as: 'view_order'
  post 'orders/:confirmation_token/view', to: 'orders#confirm', as: 'confirm_order'  
end
