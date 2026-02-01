class Transaction < ApplicationRecord
  # Associations
  belongs_to :account
  belongs_to :category, optional: true

  # Enums
  enum transaction_type: {
    income: 0,
    expense: 1,
    transfer: 2
  }

  # Validations
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true
  validates :date, presence: true
  validates :description, presence: true

  # Scopes
  scope :income, -> { where(transaction_type: :income) }
  scope :expenses, -> { where(transaction_type: :expense) }
  scope :transfers, -> { where(transaction_type: :transfer) }
  scope :by_date, -> { order(date: :desc) }
  scope :for_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }

  # Callbacks
  after_create :update_account_balance
  after_update :update_account_balance, if: :saved_change_to_amount?
  after_destroy :update_account_balance

  private

  def update_account_balance
    account.reload
    total_income = account.transactions.income.sum(:amount)
    total_expenses = account.transactions.expenses.sum(:amount)
    account.update_column(:balance, total_income - total_expenses)
  end
end
