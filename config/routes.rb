# frozen_string_literal: true

Rails.application.routes.draw do
  get 'contacts/index'
  root to: 'welcome#index'

  resources :sessions, only: %i[new create destroy]

  resources :users do
    resource :basket, only: %i[show] do
      post :add_product
    end

    resources :basket, only: %i[update destroy], controller: :baskets, as: :basket_items

    resources :orders, only: %i[index create show destroy], shallow: true do
      member do
        get :pay
        get :confirm_payment
        get :confirm
        post :confirm_shipment
        post :confirm_receipt
      end
    end
  end

  resources :products

  namespace :management do
    resources :messages, only: %i[index create destroy]
  end

  get '/contacts', to: 'contacts#index'
  post '/set_language/:lang', to: 'welcome#set_language', as: :set_language
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
