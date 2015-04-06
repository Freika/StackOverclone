Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, except: :index do
      patch :mark_as_solution, on: :member
    end
  end
end
