require "test_helper"

class Api::V1::TransactionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
    @api_key = @user.generate_api_key
    @account = @user.accounts.create!(name: "Main Checking", account_type: :checking, balance: 1000)
    @category = @user.categories.create!(name: "Groceries")
    @transaction = @account.transactions.create!(
      amount: 50.00,
      transaction_type: :expense,
      date: Date.today,
      description: "Grocery shopping",
      category: @category
    )
  end

  test "should get index for all transactions" do
    get api_v1_transactions_url, headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
  end

  test "should get index for account transactions" do
    get api_v1_account_transactions_url(@account), headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
  end

  test "should show transaction" do
    get api_v1_transaction_url(@transaction), headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @transaction.amount.to_s, json_response["amount"]
  end

  test "should create transaction" do
    assert_difference("Transaction.count") do
      post api_v1_account_transactions_url(@account), headers: { "Authorization" => "Bearer #{@api_key}" }, params: {
        transaction: {
          amount: 100.00,
          transaction_type: "income",
          date: Date.today,
          description: "Salary",
          category_id: @category.id
        }
      }, as: :json
    end
    assert_response :created
  end

  test "should update transaction" do
    patch api_v1_transaction_url(@transaction), headers: { "Authorization" => "Bearer #{@api_key}" }, params: {
      transaction: { amount: 75.00 }
    }, as: :json
    assert_response :success
    @transaction.reload
    assert_equal 75.00, @transaction.amount
  end

  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      delete api_v1_transaction_url(@transaction), headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    end
    assert_response :no_content
  end

  test "should filter transactions by date range" do
    get api_v1_transactions_url(start_date: 1.week.ago, end_date: Date.today), headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    assert_response :success
  end

  test "should filter transactions by type" do
    get api_v1_transactions_url(transaction_type: "expense"), headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
  end
end
