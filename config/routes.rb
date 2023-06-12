# frozen_string_literal: true

Rails.application.routes.draw do
  # get 'home/index'
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations' }

  # root 'home#index'
  devise_scope :user do
    root to: 'users/sessions#new', as: :unauthenticated_root
    get '/profile/edit' => 'users/registrations#edit', as: :edit_profile
    # put "/profile" => "users/registrations#update"
  end

  get '/schedule' => 'home#index', as: :schedule
end
