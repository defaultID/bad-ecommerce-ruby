# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :sessions, only: %i[new create destroy]
  resources :users
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
