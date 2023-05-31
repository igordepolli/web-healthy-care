# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  scope(path_names: { new: "novo", edit: "editar" }) do
    constraints lambda { |request| Rails.env.development? || User.find(request.cookie_jar.signed["user_id"]).admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end

    root to: "home#show"

    devise_for :users, path: "usuarios",
                       path_names: { sign_in: "login", sign_up: "registrar", sign_out: "logout", password: "senha" },
                       controllers: { registrations: "users/registrations" }

    resource :dispatches,                            only: :show,                                   path: "ir-para"
    resources :doctors,                              only: [:new, :show, :create],                  path: "medicos"
    resources :patients,                             only: [:new, :create, :index],                 path: "pacientes" do
      scope module: :patients do
        resources :access_controls,                  only: [:create, :update, :destroy, :index],    path: "autorizacoes"
        resource  :dashboard,                        only: :show
        resources :consultations,                    only: [:new, :create, :show, :index],          path: "consultas"
        resources :surgeries,                        only: [:new, :create, :show, :index],          path: "cirurgias"
        resources :diagnostics,                      only: [:new, :create, :show, :index, :update], path: "diagnosticos" do
          scope module: :diagnostics do
            resources :treatments,                   only: [:new, :show, :index, :update],          path: "tratamentos"
            resources :diets,                        only: [:new, :create],                         path: "dietas"
            resources :prescriptions,                only: [:new, :create],                         path: "receitas" do
              scope module: :prescriptions do
                resources :medication_prescriptions, only: [:new, :create],                         path: "medicamentos"
              end
            end
            resources :surgeries,                    only: [:new, :create],                         path: "cirurgias"
          end
        end
      end
    end
  end
end
