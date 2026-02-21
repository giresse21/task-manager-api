class Task < ApplicationRecord
  # Relations
  belongs_to :user
  belongs_to :project

  # Validations
  validates :title, presence: true

  # Valeur par défaut pour completed
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.completed ||= false
    self.priority ||= "medium"
  end
end
