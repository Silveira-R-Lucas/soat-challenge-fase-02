Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "api/v1/register" => "api/v1/clients#create"
  post "api/v1/sign_in" => "api/v1/clients#identify_session"

  post "api/v1/create_product" => "api/v1/products#create"
  get "api/v1/products_by_category/:category" => "api/v1/products#find_by_category"
  delete "api/v1/remove_product_from_catalog/:product_id" => "api/v1/products#remove_product_from_catalog"
  match "api/v1/update_product/:product_id" => "api/v1/products#update", via: [:patch, :post]

  post "api/v1/cart/" => "api/v1/carts#create_order"
  get "api/v1/cart/" => "api/v1/carts#show"
  post "api/v1/cart/:cart_id/update", to: "api/v1/carts#update_order"
  delete "api/v1/cart/:product_id" => "api/v1/carts#remove_order"
  post "api/v1/cart/:cart_id/checkout" => "api/v1/carts#checkout"
  get "api/v1/cart/list_checked_out_orders" => "api/v1/carts#list_checked_out_orders"
  get "api/v1/cart/list_in_progress_orders" => "api/v1/carts#list_in_progress_orders"

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
