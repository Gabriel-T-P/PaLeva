Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
  resources :establishments, only: [:new, :create, :edit, :update, :show, :destroy] do
    resources :opening_hours, only: [:edit, :update, :new, :create, :destroy]
    resources :items, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :portions, only: [:show, :new, :create, :edit, :update, :destroy] do
        patch :set_active, on: :member
        patch :set_unactive, on: :member
      end
    end
    resources :beverages, only: [:show, :new, :create, :edit, :update, :destroy] do
      resources :portions, only: [:show, :new, :create, :edit, :update, :destroy] do
        patch :set_active, on: :member
        patch :set_unactive, on: :member
      end
    end
  end
end