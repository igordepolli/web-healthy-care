# frozen_string_literal: true

module Patients::AccessControlsHelper
  def authorization_action(patient, access_control, method)
    if method == :patch
      hover_color = "green"
      icon        = :authorizations
      icon_color  = "#0E9F6E"
    else
      hover_color = "red"
      icon        = :denied
      icon_color  = "#F05252"
    end

    fudgeball_form model: access_control, url: patient_access_control_path(patient, access_control), method: do
      concat(content_tag("button", type: :submit, data: { dismiss_target: "##{dom_id(access_control)}" }, aria: { label: "Close" }, class: "bg-blue-50 text-blue-500 rounded-lg focus:ring-2 focus:ring-blue-400 p-1.5 hover:bg-#{hover_color}-200 inline-flex h-8 w-8") do
        fudgeball_icon icon, color: icon_color, size: 20
      end)
    end
  end
end
