Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchants/items"
      end
      get "/items/:id/merchant", to: "merchants/items#show"
  

      resources :items, only: [:index, :show, :create, :update, :destroy]
    end
  end

  
  # Defines the root path route ("/")
  # root "articles#index"
end
