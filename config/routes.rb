Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
  resources :home
  resources :about
  resources :shop
  resources :coupons
  resources :contact
  resources :products, only: :info_product, param: :meta_title do
    collection do
      get 'info-product/:meta_title', to: 'products#info_product'
    end
  end
  resources :products, except: :info_product do
    collection do
      get 'filter'
      get 'show-more', to: 'products/show_more'
      get 'get-quantity-in-stock', to: 'products/get_quantity_in_stock'
    end
    resources :comments
    resources :product_images
    resources :product_price_logs
    resources :reviews
    resources :inventories
  end
  resources :suppliers do
    resources :products
  end
end
