Rails.application.routes.draw do
  root to: "homepage#home"
  resources :sessions, only: [:create, :destroy]
  resources :users, only: [:create, :show, :index]
  resources :transactions, only: [:create, :update]
  resources :cars, only: [:index, :show, :create]
  post '/', to: 'homepage#home'
  get 'signout', to: 'sessions#destroy', as: 'signout'
end