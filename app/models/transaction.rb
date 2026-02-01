class Transaction < ApplicationRecord
  # Associations
  belongs_to :account
  belongs_to :category, optional: true

  # Enums
  enum :transaction_type, {
    income: 0,
    expense: 1,
    transfer: 2
  }

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
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
  after_create :adjust_account_balance
  after_update :adjust_account_balance, if: :saved_change_to_amount?
  before_destroy :store_old_values
  after_destroy :adjust_account_balance_after_destroy

  private

  def adjust_account_balance
    return unless persisted? || destroyed?

    delta = calculate_balance_delta
    account.update_column(:balance, account.balance + delta)
  end

  def adjust_account_balance_after_destroy
    delta = -calculate_balance_delta_for_destroyed
    account.update_column(:balance, account.balance + delta)
  end

  def calculate_balance_delta
    new_impact = transaction_type == "income" ? amount : -amount

    if saved_change_to_amount? || saved_change_to_transaction_type?
      old_amount = saved_change_to_amount? ? amount_before_last_save : amount
      old_type = saved_change_to_transaction_type? ? transaction_type_before_last_save : transaction_type
      old_impact = old_type == "income" ? old_amount : -old_amount
      new_impact - old_impact
    else
      new_impact
    end
  end

  def store_old_values
    @old_amount = amount
    @old_transaction_type = transaction_type
  end

  def calculate_balance_delta_for_destroyed
    @old_transaction_type == "income" ? @old_amount : -@old_amount
  end
end
