# frozen_string_literal: true

module Exam::Biodata
  extend ActiveSupport::Concern

  included do
    def build_biodatum(**args)
      super args.merge(patient:)
    end
  end
end
