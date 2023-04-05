class CreateDiets < ActiveRecord::Migration[7.0]
  def change
    create_table :diets do |t|
      t.references :source, null: false, polymorphic: true
      t.string :breakfast, null: false
      t.string :lunch, null: false
      t.string :dinner, null: false
      t.string :morning_snack
      t.string :afternoon_snack

      t.timestamps
    end
  end
end
