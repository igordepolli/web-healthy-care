class CreateDiagnostics < ActiveRecord::Migration[7.0]
  def change
    create_table :diagnostics do |t|
      t.references :disease, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.date :diagnosed_at, null: false
      t.date :cured_at
      t.string :related_symptoms
      t.integer :status, null: false, default: 1

      t.timestamps
    end

    add_index :diagnostics, [:disease_id, :patient_id, :status], unique: true
  end
end
