class User < ApplicationRecord
  # Relations
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Authentification
  has_secure_password
end
