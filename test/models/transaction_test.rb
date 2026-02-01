require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
    @account = @user.accounts.create!(name: "Main Checking", account_type: :checking, balance: 1000)
    @category = @user.categories.create!(name: "Groceries")
  end

  test "should not save transaction without amount" do
    transaction = @account.transactions.build(
      transaction_type: :expense,
      date: Date.today,
      description: "Test"
    )
    assert_not transaction.save, "Saved the transaction without amount"
  end

  test "should not save transaction without date" do
    transaction = @account.transactions.build(
      amount: 50.00,
      transaction_type: :expense,
      description: "Test"
    )
    assert_not transaction.save, "Saved the transaction without date"
  end

  test "should save transaction with valid attributes" do
    transaction = @account.transactions.build(
      amount: 50.00,
      transaction_type: :expense,
      date: Date.today,
      description: "Grocery shopping",
      category: @category
    )
    assert transaction.save, "Failed to save the transaction with valid attributes"
  end

  test "should update account balance after creating income transaction" do
    initial_balance = @account.balance
    @account.transactions.create!(
      amount: 100.00,
      transaction_type: :income,
      date: Date.today,
      description: "Salary"
    )
    @account.reload
    assert_equal initial_balance + 100.00, @account.balance
  end

  test "should update account balance after creating expense transaction" do
    initial_balance = @account.balance
    @account.transactions.create!(
      amount: 50.00,
      transaction_type: :expense,
      date: Date.today,
      description: "Groceries"
    )
    @account.reload
    assert_equal initial_balance - 50.00, @account.balance
  end
end
