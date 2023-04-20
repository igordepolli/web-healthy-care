class CreateDiets < ActiveRecord::Migration[7.0]
  def change
    create_table :diets do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :breakfast
      t.string :lunch
      t.string :dinner
      t.string :morning_snack
      t.string :afternoon_snack

      t.timestamps
    end
  end
end
