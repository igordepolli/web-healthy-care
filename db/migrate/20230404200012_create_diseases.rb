class CreateDiseases < ActiveRecord::Migration[7.0]
  def change
    create_table :diseases do |t|
      t.string :name, null: false
      t.string :treatment_indicated

      t.timestamps
    end

    add_index :diseases, :name
  end
end
