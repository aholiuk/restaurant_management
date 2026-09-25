Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "dashboard", to: "dashboard#index"
  get "profile/confirm_email/:token", to: "profiles#confirm_email", as: :confirm_email
  get "cart", to: "cart#show"
  post "cart/add/:menu_item_id", to: "cart#add", as: :add_to_cart
  post "cart/remove/:menu_item_id", to: "cart#remove", as: :remove_from_cart
  get "checkout", to: "orders#new"
  post "checkout", to: "orders#create"
  get "orders/:id/confirmation", to: "orders#confirmation", as: :order_confirmation
  get "activity", to: "activity#index"
  post "cart/decrease/:menu_item_id", to: "cart#decrease", as: :decrease_cart_item
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resource :registration, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resource :profile, only: [:show, :edit, :update]
  resources :employees, only: [:index, :edit, :update, :destroy]
  resources :menu_items, path: "menu"
  resource :setting, only: [:edit, :update]
  resources :orders, only: [:index] do
    member do
      patch :advance
    end
  end
  root "menu_items#index"

end
