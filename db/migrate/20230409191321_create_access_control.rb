class CreateAccessControl < ActiveRecord::Migration[7.0]
  def change
    create_table :access_controls do |t|
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end