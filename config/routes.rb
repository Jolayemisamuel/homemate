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
    scope module: :landlords do
      resources :contacts
      resources :users do
        post :unlock, on: :member
      end
    end
  end

  resources :properties, shallow: true do
    resources :tenancies

    resources :rooms do
      resources :tenancies
    end

    resources :utilities, only: [:index, :new, :create]
  end

  resources :tenants do
    scope module: :tenants do
      resources :checks
      resources :contacts
      resources :users do
        post :unlock, on: :member
      end
    end
  end

  resources :utilities, only: [:show, :edit, :update, :destroy] do
    scope module: :utilities do
      resources :prices, only: [:edit, :update, :new, :create, :destroy]
      resources :usages, only: [:index, :new, :create, :destroy]
    end
  end

  resources :users, only: [:edit, :update]

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
