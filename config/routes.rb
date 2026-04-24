Rails.application.routes.draw do
  root "cmanager#index"
  get "cmanager/index"
  get "/publicbanner(/*ip)", to: "cmanager#get_public_banner", format: false

  namespace :api do
    namespace :v1 do
      resource :current_user, only: :show
      resources :campaigns, only: [ :index, :create, :destroy ]
      resources :banners, only: [ :index, :create, :destroy ]
    end
  end

  resources :users, only: [ :show, :new, :create ] do
    resources :campaigns, only: :index
    resources :banners, only: :index
  end

  # Authentication
  get "/newuser", to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
