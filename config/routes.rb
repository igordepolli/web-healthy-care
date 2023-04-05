Rails.application.routes.draw do
  devise_for :users

  resources :patients, only: [:new, :show, :create]

  root to: "home#show"
end
