Rails.application.routes.draw do
  get 'pages/home'

  root 'pages#home'
  
  devise_for :users
  resources :orders, ecxept: [:show]
  get 'orders/:confirmation_token/view', to: 'orders#view_order', as: 'view_order'
  post 'orders/:confirmation_token/view', to: 'orders#confirm', as: 'confirm_order'
end
