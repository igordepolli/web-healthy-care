class CreateMedicationSurgeries < ActiveRecord::Migration[7.0]
  def change
    create_table :medication_surgeries do |t|
      t.references :surgery, null: false, foreign_key: true
      t.references :medication, null: false, foreign_key: true
      t.string :dosage, null: false

      t.timestamps
    end
  end
end
