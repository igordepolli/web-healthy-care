class CreateTreatments < ActiveRecord::Migration[7.0]
  def change
    create_table :treatments do |t|
      t.references :disease_patient, null: false, foreign_key: true
      t.integer :classification, null: false
      t.string :recommendation
      t.datetime :started_at, null: false
      t.datetime :ended_at

      t.timestamps
    end
  end
end
