class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :crm, null: false
      t.string :cpf, null: false
      t.string :email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    remove_index :doctors, :user_id, if_exists: true
    add_index :doctors, :user_id, unique: true
    add_index :doctors, :crm, unique: true
    add_index :doctors, :cpf, unique: true
    add_index :doctors, :email, unique: true
  end
end
