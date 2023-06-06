# frozen_string_literal: true

class Patients::BiodataController < Patients::DashboardsController
  before_action :set_biodatum, only: :show

  def index
    @biodata = @patient.biodata
  end

  def show
  end

  private
    def set_biodatum
      @biodatum = @patient.biodata.find { _1.id == params[:id].to_i }
    end
end
