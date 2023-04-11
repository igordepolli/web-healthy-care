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

Patient.create! user: leo,    name: "Leonardo", last_name: "Maralha"
Patient.create! user: oreo,   name: "Oreo",     last_name: "Depolli"
Doctor.create!  user: milena, name: "Milena",   last_name: "Regiani", cpf: "153.316.417-76", crm: "CRM/SP 123456"
