Rails.application.routes.draw do
  devise_for :users, path: "", path_names: { sign_in: "login", sign_up: "registrar", sign_out: "logout", password: "senha" }

  resources :patients, only: [:new, :show, :create]

  root to: "home#show"
end
