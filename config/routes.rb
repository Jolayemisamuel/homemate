Rails.application.routes.draw do
  root 'pages#home'

  scope '/billing' do
    resources :mandates do
      get :complete, on: :new
    end
    resources :invoices
    resources :transactions
  end

  resources :properties, shallow: true do
    resources :tenancies, only: [:index, :new, :create]

    resources :rooms, only: [:index, :new, :create, :destroy] do
      resources :tenancies, only: [:index, :new, :create]
    end

    resources :utilities do
      resources :prices, only: [:new, :create, :destroy], controller: 'utility_prices'
      resources :usages, only: [:index, :new, :create, :destroy], controller: 'utility_usages'
    end
  end

  resources :tenants do
    resources :checks, controller: 'tenant_checks'
  end

  resources :tenancies, except: [:new, :create]

  devise_for :users, controllers: {
      sessions: 'users/sessions'
  }
end
