# frozen_string_literal: true

module Patients::AccessControlsHelper
  def authorization_action(patient, access_control, method, icon_size: 20)
    if method == :patch
      color = :green
      icon  = :authorizations
    else
      color = :red
      icon  = :denied
    end

    fudgeball_form model: access_control, url: patient_access_control_path(patient, access_control), method: do
      concat(content_tag("button", type: :submit, data: { dismiss_target: "##{dom_id(access_control)}" }, aria: { label: "Close" }, class: "bg-blue-50 text-blue-500 rounded-lg focus:ring-2 focus:ring-blue-400 py-1.5 hover:bg-#{color}-200 inline-flex h-8 w-8") do
        fudgeball_icon icon, color:, size: icon_size
      end)
    end
  end
end
