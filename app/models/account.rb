class Account < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions, dependent: :destroy

  # Enums
  enum :account_type, {
    checking: 0,
    savings: 1,
    credit_card: 2,
    investment: 3,
    cash: 4,
    other: 5
  }

  # Validations
  validates :name, presence: true
  validates :account_type, presence: true
  validates :balance, presence: true, numericality: true
  validates :currency, presence: true

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.balance ||= 0.0
    self.currency ||= "USD"
  end
end
