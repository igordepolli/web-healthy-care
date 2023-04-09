# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Classifiable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :last_name, presence: true

  def full_name
    "#{name} #{last_name}"
  end
end
