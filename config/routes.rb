Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations'
   }

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
