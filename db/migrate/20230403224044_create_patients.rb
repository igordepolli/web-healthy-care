class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.integer :rg
      t.integer :cpf
      t.string :email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
