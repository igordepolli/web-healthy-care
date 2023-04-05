class CreateMedicationPrescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :medication_prescriptions do |t|
      t.references :prescription, null: false, foreign_key: true
      t.references :medication, null: false, foreign_key: true
      t.string :dosage, null: false
      t.string :schedule, null: false

      t.timestamps
    end
  end
end
