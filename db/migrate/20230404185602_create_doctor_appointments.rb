class CreateDoctorAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :doctor_appointments do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.datetime :date, null: false
      t.string :reason

      t.timestamps
    end
  end
end
