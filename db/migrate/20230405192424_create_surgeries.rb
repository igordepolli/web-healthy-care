class CreateSurgeries < ActiveRecord::Migration[7.0]
  def change
    create_table :surgeries do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :source, null: false, polymorphic: true
      t.integer :classification, null: false
      t.date :date, null: false
      t.string :hospital
      t.date :discharged_at

      t.timestamps
    end
  end
end
