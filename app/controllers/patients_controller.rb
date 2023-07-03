# frozen_string_literal: true

class PatientsController < ApplicationController
  include PatientScoped

  def new
  end

  def edit
  end

  def index
    # Exemplo simples de uso do ActiveRecord: Chamamos o modelo 'Patient' com o método where método este cujo primeiro argumento é uma string com uma query SQL e o segundo argumento é o valor que deve ser substituído no lugar do '?' na query SQL. Ao final, é assim que o ActiveRecord monta a query SQL: SELECT "patients".* FROM "patients" WHERE (last_name ~* 'valor_do_parametro_query')
    @patients = Patient.where("last_name ~* ?", params[:query])
  end

  def create
    @patient.assign_attributes user: current_user, **patient_params_create

    if @patient.save
      redirect_to patient_dashboard_path(@patient)
    else
      flash[:error] = @patient.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @patient.assign_attributes patient_params_update

    if @patient.save
      redirect_to patient_dashboard_path(@patient)
    else
      flash[:error] = @patient.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def patient_params_create
      params.require(:patient).permit(:name, :last_name, :rg, :cpf, :email, :city, :state)
    end

    def patient_params_update
      params.require(:patient).permit(:name, :last_name, :email, :city, :state)
    end
end
