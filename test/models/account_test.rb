require "test_helper"

class AccountTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
  end

  test "should not save account without name" do
    account = @user.accounts.build(account_type: :checking)
    assert_not account.save, "Saved the account without a name"
  end

  test "should save account with valid attributes" do
    account = @user.accounts.build(name: "Main Checking", account_type: :checking)
    assert account.save, "Failed to save the account with valid attributes"
  end

  test "should have default balance of 0" do
    account = @user.accounts.create!(name: "Main Checking", account_type: :checking)
    assert_equal 0.0, account.balance
  end

  test "should have default currency of USD" do
    account = @user.accounts.create!(name: "Main Checking", account_type: :checking)
    assert_equal "USD", account.currency
  end
end
