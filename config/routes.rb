Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'user#dashboard'
  get 'leaderboard', to: 'user#leaderboard', as: 'leaderboard'
  get 'rules', to: 'user#rules', as: 'rules'

  devise_for :users, skip: :sessions, controllers: { registrations: 'registrations' }
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :predictions
end
