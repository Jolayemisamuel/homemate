##
# Copyright (c) Andrew Ying 2017-18.
#
# This file is part of HomeMate.
#
# HomeMate is free software: you can redistribute it and/or modify
# it under the terms of version 3 of the GNU General Public License
# as published by the Free Software Foundation. You must preserve
# all reasonable legal notices and author attributions in this program
# and in the Appropriate Legal Notice displayed by works containing
# this program.
#
# HomeMate is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HomeMate.  If not, see <http://www.gnu.org/licenses/>.
##

Rails.application.routes.draw do
  root 'pages#home'

  resources :applications, controller: 'tenants/applications' do
    resources :documents, controller: 'tenants/application_documents', only: [:new, :create]
  end

  scope 'billing' do
    resources :mandates do
      get :complete, on: :new
    end
    resources :invoices
    resources :transactions do
      get 'failed', to: 'transactions#failed'
    end
    post 'webhook', to: 'billing#webhook'
  end

  resources :landlords, except: [:index, :destroy] do
    scope module: :landlords do
      resources :contacts
      resources :users do
        post :unlock, on: :member
      end
    end
  end

  resource :profile, controller: 'profile', only: [:edit, :update]

  scope 'profile' do
    resources :contacts
    resources :users, except: [:index]
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

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
