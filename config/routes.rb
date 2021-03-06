# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :sessions, only: %i[new create destroy]

  resources :users do
    resource :basket, only: %i[show] do
      post :add_product
    end

    resources :basket, only: %i[update destroy], controller: :baskets, as: :basket_items

    resources :orders, only: %i[create show destroy], shallow: true do
      collection do
        get :index, constraints: ->(req) { req.format == :html }
        post :index, action: :xml_index, constraints: ->(req) { req.format == :xml }
      end
      member do
        get :pay
        get :confirm_payment
        get :confirm
        post :confirm_shipment
        post :confirm_receipt
      end
    end

    member do
      get :picture, action: :show_picture
    end
  end

  resources :products

  namespace :management do
    resources :messages, only: %i[index create destroy]
  end

  get '/contacts', to: 'contacts#index'
  get '/oauth', to: 'oauth#code'
  post '/oauth', to: 'oauth#token'
  post '/set_language/:lang', to: 'welcome#set_language', as: :set_language
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
