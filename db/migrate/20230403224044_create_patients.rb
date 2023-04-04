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

    remove_index :patients, :user_id, if_exists: true
    add_index :patients, :user_id, unique: true
  end
end
