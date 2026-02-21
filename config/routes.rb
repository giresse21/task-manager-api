Rails.application.routes.draw do
  # Health check
  get "/health", to: "health#index"

  # API v1
  namespace :api do
    namespace :v1 do
      # Authentication
      post "/signup", to: "auth#signup"
      post "/login", to: "auth#login"
      get "/me", to: "auth#me"

      # Resources
      resources :projects do
        resources :tasks, only: [ :index, :create ]
      end

      resources :tasks, only: [ :show, :update, :destroy ] do
        member do
          patch :toggle
        end
      end
    end
  end
end
