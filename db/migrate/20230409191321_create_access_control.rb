class CreateAccessControl < ActiveRecord::Migration[7.0]
  def change
    create_table :access_controls do |t|
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.datetime :expires_at
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :access_controls, [:doctor_id, :patient_id, :status], unique: true, name: "idx_doctor_patient_status_on_ac"
  end
end
