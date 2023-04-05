class CreateBiodatas < ActiveRecord::Migration[7.0]
  def change
    create_table :biodata do |t|
      t.references :source, null: false, polymorphic: true
      t.integer :systolic_pressure
      t.integer :diastolic_pressure
      t.integer :glycemia
      t.integer :heart_rate
      t.integer :cholesterol
      t.integer :triglyceride
      t.decimal :creatinine

      t.timestamps
    end
  end
end
