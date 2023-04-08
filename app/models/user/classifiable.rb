# frozen_string_literal: true

module User::Classifiable
  extend ActiveSupport::Concern

  included do
    enum :classification, { admin: 0, patient: 1, doctor: 2 }

    def self.public_classifications
      classifications.except("admin")
    end

    validates :classification, presence: true, inclusion: { allow_blank: true, in: public_classifications.keys }
  end
end
