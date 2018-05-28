Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'user#dashboard'
  get 'leaderboard', to: 'user#leaderboard', as: 'leaderboard'

  devise_for :users, skip: %i(sessions registrations)
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    get 'password/change' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'password/change' => 'devise/registrations#update', :as => 'user_registration'
  end

  resources :predictions
end
