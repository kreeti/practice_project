Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure"
  get "signout", to: "sessions#destroy", as: "signout"
  get "/signin", to: redirect("/auth/google_oauth2")

  resources :users

  resources :vendors

  resources :bills

  resources :sessions, only: :none do
    member do
      get  :two_factor_authentication
      post :authenticate
    end
  end

  resources :accounts do
    get :list, on: :collection
  end

  resources :credit_transactions, except: [:index] do
    member do
      put "approve"
      get "reject_transaction"
      patch "reject"
    end
  end

  resources :transactions do
    member do
      put "approve"
      get "reject_transaction"
      patch "reject"
      delete "remove_attachment"
    end
  end

  resources :reports, only: [:index]
  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]
  root to: "home#index"
end
