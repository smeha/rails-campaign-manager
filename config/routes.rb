Rails.application.routes.draw do
  root "cmanager#index"
  get 'cmanager/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
