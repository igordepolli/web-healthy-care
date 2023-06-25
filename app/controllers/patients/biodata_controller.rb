# frozen_string_literal: true

class Patients::BiodataController < Patients::DashboardsController
  def show
    @biodatum = @patient.biodatum
  end
end
