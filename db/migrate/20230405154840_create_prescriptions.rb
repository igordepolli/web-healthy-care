class CreatePrescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :prescriptions do |t|
      t.references :patient, null: false, foreign_key: true
      t.date :date, null: false
      t.timestamps
    end
  end
end
