# frozen_string_literal: true

# Admin
User.insert({
  email: "igorcler@gmail.com",
  name: "Igor",
  last_name: "Depolli",
  encrypted_password: User.new.send(:password_digest, "123456"),
  classification: :admin
})

# Patients and Doctors
leo    = User.create! email: "leo@gmail.com",    name: "Leonardo", last_name: "Maralha", password: "123456", classification: :patient
milena = User.create! email: "milena@gmail.com", name: "Milena",   last_name: "Regiani", password: "123456", classification: :doctor

leo.profile_photo.attach    io: File.open(Rails.root.join("test/fixtures/files", "cj.jpeg")), filename: "cj"
milena.profile_photo.attach io: File.open(Rails.root.join("test/fixtures/files", "cj.jpeg")), filename: "cj"

leo_patient   = Patient.create! user: leo,    name: "Leonardo", last_name: "Maralha", email: "leo@gmail.com"
milena_doctor = Doctor.create!  user: milena, name: "Milena",   last_name: "Regiani", email: "milena@gmail.com", cpf: "153.316.417-76", crm: "CRM/SP 123456"

# Authorizations
AccessControl.create! doctor: milena_doctor, patient: leo_patient, expires_at: Time.zone.now + 2.hours
