# frozen_string_literal: true

User.insert({
  email: "igorcler@gmail.com",
  name: "Igor",
  last_name: "Depolli",
  encrypted_password: User.new.send(:password_digest, "123456"),
  classification: :admin
})

leo    = User.create! email: "leo@gmail.com",    name: "Leonardo", last_name: "Maralha", password: "123456", classification: :patient
milena = User.create! email: "milena@gmail.com", name: "Milena",   last_name: "Regiani", password: "123456", classification: :doctor
oreo   = User.create! email: "oreo@gmail.com",   name: "Oreo",     last_name: "Depolli", password: "123456", classification: :patient

leo.profile_photo.attach    io: File.open(Rails.root.join("test/fixtures/files", "cj.jpeg")), filename: "cj"
milena.profile_photo.attach io: File.open(Rails.root.join("test/fixtures/files", "cj.jpeg")), filename: "cj"

Patient.create! user: leo,    name: "Leonardo", last_name: "Maralha", email: "leo@gmail.com"
Patient.create! user: oreo,   name: "Oreo",     last_name: "Depolli", email: "oreo@gmail.com"
Doctor.create!  user: milena, name: "Milena",   last_name: "Regiani", email: "milena@gmail.com", cpf: "153.316.417-76", crm: "CRM/SP 123456"
