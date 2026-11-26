Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  # 
  
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      resources :users, only: [:create]
      get "current", to: "sessions#current"
      delete "logout", to: "sessions#destroy"
      get "profile", to: "users#profile"
      patch "profile", to: "users#update_profile"

      get "favorites", to: "favorites#index"
      get "posts/:post_id/favorite",to: "favorites#status"
      post "posts/:post_id/favorites", to: "favorites#create"
      delete "posts/:post_id/favorites", to: "favorites#destroy"
      
      post "subscription", to: "subscriptions#create"

      get "posts/:post_id/comments", to:"comments#index"
      post "posts/:post_id/comments", to:"comments#create"
      delete "comments/:id", to: "comments#destroy"

      resources :tags, param: :slug, only: [:index] do
        member do
          get :posts
        end
      end

      resources :posts, param: :slug, only: [:index, :show]

    end
  end

end
