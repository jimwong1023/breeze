Rails.application.routes.draw do
  root to: "homepage#home"
  resources :sessions, only: [:create, :destroy]
  resources :users, only: [:create, :show]
  resources :transactions, only: [:create]
  resources :cars, only: [:index, :show]
  get 'signout', to: 'sessions#destroy', as: 'signout'
end