Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchants/items"
      end
    end
  end
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index]
    end
  end

  
  # Defines the root path route ("/")
  # root "articles#index"
end
