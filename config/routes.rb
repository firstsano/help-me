Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "registrations"
  }

  get "users/auth/email_confirmation", to: "users/omniauth_callbacks#new_auth"
  post "users/auth/email_confirmation", to: "users/omniauth_callbacks#register_auth"
  get "users/auth/confirm", to: "users/omniauth_callbacks#confirm_auth"

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

  api_version(module: "Api::V1", path: { value: "api/v1" }, defaults: { format: :json }, default: true) do
    resources :profiles, only: :index do
      get :me, on: :collection
    end
    resources :questions
  end

  root to: "questions#index"
end
