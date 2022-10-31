Rails.application.routes.draw do
  devise_for :admins
  #devise_for :users
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
  resources :home
  resources :about
  resources :shop
  resources :coupons
  resources :contact
  resources :products, except: :show do
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
  resources :products, only: :show, param: :meta_title do
    collection do
      #get 'info-product/:meta_title', to: 'products#info_product'
      get ':meta_title', to: 'products#show'
    end
  end
  resources :comments do
    collection do
      get 'show-more', to: 'comments/show_more'
    end
  end
  resources :reviews do
    collection do
      post 'favorite'
    end
  end
  resources :suppliers do
    resources :products
  end
end
