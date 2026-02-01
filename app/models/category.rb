class Category < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions, dependent: :nullify

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id, message: "already exists for this user" }
end
