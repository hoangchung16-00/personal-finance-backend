require "test_helper"

class Api::V1::ApiKeyAuthenticationTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
    @api_key = @user.generate_api_key
    @account = @user.accounts.create!(name: "Test Account", account_type: :checking, balance: 1000)
  end

  test "should authenticate with valid API key in Authorization header" do
    get api_v1_accounts_url, 
        headers: { "Authorization" => "Bearer #{@api_key}" },
        as: :json
    
    assert_response :success
  end

  test "should reject request without API key" do
    get api_v1_accounts_url, as: :json
    
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal "Invalid or missing API key", json_response["error"]
  end

  test "should reject request with invalid API key" do
    get api_v1_accounts_url,
        headers: { "Authorization" => "Bearer invalid_key_123" },
        as: :json
    
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal "Invalid or missing API key", json_response["error"]
  end

  test "should reject request with malformed Authorization header" do
    get api_v1_accounts_url,
        headers: { "Authorization" => "#{@api_key}" }, # Missing "Bearer "
        as: :json
    
    assert_response :unauthorized
  end

  test "authenticated user can access their accounts" do
    get api_v1_accounts_url,
        headers: { "Authorization" => "Bearer #{@api_key}" },
        as: :json
    
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
    assert_equal @account.name, json_response[0]["name"]
  end

  test "authenticated user can create account" do
    assert_difference("Account.count") do
      post api_v1_accounts_url,
           headers: { "Authorization" => "Bearer #{@api_key}" },
           params: { account: { name: "Savings", account_type: "savings", balance: 5000 } },
           as: :json
    end
    
    assert_response :created
  end

  test "authenticated user can access specific account" do
    get api_v1_account_url(@account),
        headers: { "Authorization" => "Bearer #{@api_key}" },
        as: :json
    
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @account.name, json_response["name"]
  end

  test "authenticated user can update their account" do
    patch api_v1_account_url(@account),
          headers: { "Authorization" => "Bearer #{@api_key}" },
          params: { account: { name: "Updated Account" } },
          as: :json
    
    assert_response :success
    @account.reload
    assert_equal "Updated Account", @account.name
  end

  test "authenticated user can delete their account" do
    assert_difference("Account.count", -1) do
      delete api_v1_account_url(@account),
             headers: { "Authorization" => "Bearer #{@api_key}" },
             as: :json
    end
    
    assert_response :no_content
  end

  test "user cannot access another user's resources" do
    other_user = User.create!(email: "other@example.com", first_name: "Jane", last_name: "Smith")
    other_account = other_user.accounts.create!(name: "Other Account", account_type: :checking, balance: 500)
    
    # Try to access other user's account with current user's API key
    # This should return 404 Not Found since the account doesn't belong to current_user
    get api_v1_account_url(other_account),
        headers: { "Authorization" => "Bearer #{@api_key}" },
        as: :json
    
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_includes json_response["error"], "Couldn't find Account"
  end

  test "revoked API key should not authenticate" do
    @user.revoke_api_key
    
    get api_v1_accounts_url,
        headers: { "Authorization" => "Bearer #{@api_key}" },
        as: :json
    
    assert_response :unauthorized
  end
end
