Rails.application.routes.draw do
  root 'pages#home'

  scope '/billing' do
    resources :mandates do
      get :complete, on: :new
    end
    resources :invoices
  end

  resources :properties, shallow: true do
    resources :rooms, only: [:new, :create, :show]
    resources :utilities do
      resources :prices, controller: 'utility_prices'
    end
  end

  resources :tenants do
    resources :checks, controller: 'tenant_checks'
  end

  resources :tenancies

  devise_for :users, controllers: {
      sessions: 'users/sessions'
  }
end
