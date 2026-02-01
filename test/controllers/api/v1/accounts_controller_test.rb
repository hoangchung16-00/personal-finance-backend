require "test_helper"

class Api::V1::AccountsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
    @account = @user.accounts.create!(name: "Main Checking", account_type: :checking, balance: 1000)
  end

  test "should get index" do
    get api_v1_accounts_url, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
  end

  test "should show account" do
    get api_v1_account_url(@account), as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @account.name, json_response["name"]
  end

  test "should create account" do
    assert_difference("Account.count") do
      post api_v1_accounts_url, params: {
        account: { name: "Savings", account_type: "savings", balance: 5000 }
      }, as: :json
    end
    assert_response :created
  end

  test "should update account" do
    patch api_v1_account_url(@account), params: {
      account: { name: "Updated Checking" }
    }, as: :json
    assert_response :success
    @account.reload
    assert_equal "Updated Checking", @account.name
  end

  test "should destroy account" do
    assert_difference("Account.count", -1) do
      delete api_v1_account_url(@account), as: :json
    end
    assert_response :no_content
  end
end
