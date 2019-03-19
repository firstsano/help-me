Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: 'questions#index'

  resources :questions do
    member do
      post :upvote
      post :downvote
    end

    resources :answers, shallow: true do
      put :best, on: :member
      post :upvote, on: :member
      post :downvote, on: :member
    end
  end
end
