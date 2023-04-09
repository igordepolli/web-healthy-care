# frozen_string_literal: true

Rails.application.routes.draw do
  scope(path_names: { new: "novo", edit: "editar" }) do
    root to: "home#show"

    devise_for :users, path: "usuarios",
                       path_names: { sign_in: "login", sign_up: "registrar", sign_out: "logout", password: "senha" },
                       controllers: { registrations: "users/registrations" }

    resource :dispatches, only: :show,                  path: "ir-para"
    resources :doctors,   only: [:new, :show, :create], path: "medicos"
    resources :patients,  only: [:new, :show, :create, :index], path: "pacientes" do
      scope module: :patients do
        resources :access_controls, only: [:create, :update, :destroy, :index]
        resources :consultations, only: [:new, :create, :show, :index], path: "consultas"
      end
    end
  end
end
