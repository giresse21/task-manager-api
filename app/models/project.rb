class Project < ApplicationRecord
  # Relations
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # Validations
  validates :name, presence: true
end
