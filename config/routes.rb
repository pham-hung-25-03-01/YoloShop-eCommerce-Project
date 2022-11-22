Rails.application.routes.draw do
  get 'checkout/index'
  get '/users/sign_in' => redirect('/home')
  match 'checkout/result' => 'checkout#result', :via => :get
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users,
    path_names: {sign_up: 'sign-up'},
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :users do
    member do
      get :confirm_email
      get '/sign_in', to: redirect('/home')
    end
    collection do
      patch 'update-user-information', to: 'users/update_user_information'
      patch 'update-user-password', to: 'users/update_user_password'
      get 'orders-history', to: 'users/orders_history'
    end
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
  resources :orders do
    collection do
      get 'get-order-details', to: 'orders/get_order_details'
    end
  end
  resources :comments do
    collection do
      get 'show-more', to: 'comments/show_more'
      post 'post'
    end
  end
  resources :reviews do
    collection do
      post 'favorite'
      post 'rating'
    end
  end
  resources :suppliers do
    resources :products
  end
  resources :cart do
    collection do
      post 'add-to-cart', to: 'cart/add_to_cart'
      post 'remove-from-cart', to: 'cart/remove_from_cart'
      post 'update-quantity', to: 'cart/update_quantity'
    end
  end
  resources :checkout do
    collection do
      get 'proceed-to-checkout', to: 'checkout/proceed_to_checkout'
      get 'back-to-cart', to: 'checkout/back_to_cart'
      post 'apply-coupon', to: 'checkout/apply_coupon'
      post 'pay', to: 'checkout/pay'
      get 'result', to: 'checkout/result'
      get 'order-success', to: 'checkout/order_success'
    end
  end
  match '*path' => redirect('/404.html'), via: :all
end
