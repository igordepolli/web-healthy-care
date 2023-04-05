class CreateSurgeries < ActiveRecord::Migration[7.0]
  def change
    create_table :surgeries do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, foreign_key: true
      t.integer :classification, null: false
      t.datetime :date, null: false
      t.string :hospital
      t.datetime :discharged_at

      t.timestamps
    end
  end
end
