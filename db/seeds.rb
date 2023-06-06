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
prescription = Prescription.new date: Time.zone.now, patient: leo_patient, medications_count: 2
prescription.file.attach io: File.open(Rails.root.join("test/fixtures/files", "sick_note.pdf")), filename: "sick_note.pdf"
prescription.save!
Treatment.create! started_at: Time.zone.now, ended_at: Time.zone.now + 1.day, diagnostic: Diagnostic.first, treatable: prescription

diet = Diet.create! patient: leo_patient, lunch: "Arroz, feijão, carne, salada", date: Time.zone.now
Treatment.create! started_at: Time.zone.now, diagnostic: Diagnostic.first, treatable: diet

surgery = Surgery.create! patient: leo_patient, classification: :urgency, date: Time.zone.now, discharged_at: Time.zone.now + 1.day
Treatment.create! started_at: Time.zone.now, diagnostic: Diagnostic.first, treatable: surgery

exam = Exam.create! patient: leo_patient, classification: :hemogram, date: Time.zone.now, local: "Laboratório Exemplo"

Biodatum.create! patient: leo_patient, exam:, systolic_pressure: 12, diastolic_pressure: 8
