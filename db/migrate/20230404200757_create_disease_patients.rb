class CreateDiseasePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :disease_patients do |t|
      t.references :disease, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.datetime :diagnostic_date, null: false
      t.datetime :cure
      t.string :related_symptoms
      t.integer :status, null: false, default: 1

      t.timestamps
    end

    add_index :disease_patients, [:disease_id, :patient_id, :status], unique: true
  end
end
