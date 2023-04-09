# frozen_string_literal: true

User.insert({
  email: "igorcler@gmail.com",
  name: "Igor",
  last_name: "Depolli",
  encrypted_password: User.new.send(:password_digest, "123456"),
  classification: :admin
})
