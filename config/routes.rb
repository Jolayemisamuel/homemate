Rails.application.routes.draw do
  root 'pages#home'

  scope '/billing' do
    resources :mandates do
      get :complete, on: :new
    end
    resources :invoices
    resources :transactions
  end

  resources :landlords do
    resources :users, shallow: true
  end

  resources :properties, shallow: true do
    resources :tenancies

    resources :rooms do
      resources :tenancies
    end

    resources :utilities do
      scope module: :utilities do
        resources :prices, only: [:new, :create, :destroy]
        resources :usages, only: [:index, :new, :create, :destroy]
      end
    end
  end

  resources :tenants do
    resources :checks, controller: 'tenant_checks'
    resources :users, shallow: true
  end

  resources :users do
    post :unlock, on: :member
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
