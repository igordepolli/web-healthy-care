# frozen_string_literal: true

class DispatchesController < ApplicationController
  def show
    if current_user.patient?
      redirect_to redirect_for_patient
    elsif current_user.doctor?
      redirect_to redirect_for_doctor
    elsif current_user.admin?
      redirect_to admin_path
    else
      raise "I don't know what to do with this user."
    end
  end

  private
    def redirect_for_patient
      patient = Patient.find_by(user: current_user)

      patient.present? ? patient_dashboard_path(patient) : new_patient_path
    end

    def redirect_for_doctor
      doctor = Doctor.find_by(user: current_user)

      doctor.present? ? doctor_path(doctor) : new_doctor_path
    end
end
