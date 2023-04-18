class CreateTreatments < ActiveRecord::Migration[7.0]
  def change
    create_table :treatments do |t|
      t.references :diagnostic, null: false, foreign_key: true
      t.references :treatable, polymorphic: true
      t.datetime :started_at, null: false
      t.datetime :ended_at

      t.timestamps
    end
  end
end
