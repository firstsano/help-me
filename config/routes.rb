Rails.application.routes.draw do
  use_doorkeeper

  api_version(module: "Api::V1", path: { value: "api/v1" }, defaults: { format: :json }, default: true) do
    resources :profiles do
      get :me, on: :collection
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations'
  }

  get 'users/auth/email_confirmation', to: 'users/omniauth_callbacks#new_auth'
  post 'users/auth/email_confirmation', to: 'users/omniauth_callbacks#register_auth'
  get 'users/auth/confirm', to: 'users/omniauth_callbacks#confirm_auth'

  root to: 'questions#index'

  concern :votable do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  concern :commentable do
    post :comment, on: :member
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      put :best, on: :member
    end
  end
end
