class CreateTreatments < ActiveRecord::Migration[7.0]
  def change
    create_table :treatments do |t|
      t.references :diagnostic, null: false, foreign_key: true
      t.references :treatable, null: false, polymorphic: true
      t.date :started_at
      t.date :ended_at

      t.timestamps
    end
  end
end
