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

# Consultations
consultation = Consultation.create! doctor: milena_doctor, patient: leo_patient, date: Time.zone.now
consultation.sick_note.attach io: File.open(Rails.root.join("test/fixtures/files", "sick_note.pdf")), filename: "sick_note.pdf"

# Medications
%w[Paracetamol Dipirona Ibuprofeno Dorflex].each { Medication.create! name: _1 }

# Diseases
%w[Gripe Cancer Gonorreia Hepatite].each { Disease.create! name: _1 }

# Diagnostics
Diagnostic.create! disease: Disease.all.sample, patient: leo_patient, diagnosed_at: Time.zone.now

# Treatments
treatment_1  = Treatment.create! started_at: Time.zone.now, ended_at: Time.zone.now + 1.day, diagnostic: Diagnostic.first
prescription = Prescription.new treatment: treatment_1
prescription.file.attach io: File.open(Rails.root.join("test/fixtures/files", "sick_note.pdf")), filename: "sick_note.pdf"
prescription.save!
treatment_1.update! treatable: prescription

treatment_2 = Treatment.create! started_at: Time.zone.now, diagnostic: Diagnostic.first
diet        = Diet.create! source: treatment_2, lunch: "Arroz, feijão, carne, salada"
treatment_2.update! treatable: diet

treatment_3 = Treatment.create! started_at: Time.zone.now, diagnostic: Diagnostic.first
surgery     = Surgery.create! source: treatment_3, classification: :urgency, date: Time.zone.now, discharged_at: Time.zone.now + 1.day
treatment_3.update! treatable: surgery
