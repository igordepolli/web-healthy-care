Rails.application.routes.draw do
  devise_for :users

  resources :patients, only: :show

  root to: "home#show"
end
