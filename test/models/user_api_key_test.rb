require "test_helper"

class UserApiKeyTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe"
    )
    @user.save!(validate: false) # Skip validations that might require password
  end

  test "generate_api_key creates and returns a valid API key" do
    api_key = @user.generate_api_key

    assert_not_nil api_key
    assert_equal 64, api_key.length # 32 bytes in hex = 64 characters
    assert_not_nil @user.api_key_digest
    assert_not_nil @user.api_key_created_at
  end

  test "generate_api_key stores hashed version" do
    api_key = @user.generate_api_key
    
    # The stored digest should not match the plain key
    assert_not_equal api_key, @user.api_key_digest
    
    # But hashing the plain key should match the stored digest
    expected_digest = Digest::SHA256.hexdigest(api_key)
    assert_equal expected_digest, @user.api_key_digest
  end

  test "authenticate_by_api_key returns user with valid key" do
    api_key = @user.generate_api_key
    
    authenticated_user = User.authenticate_by_api_key(api_key)
    
    assert_not_nil authenticated_user
    assert_equal @user.id, authenticated_user.id
  end

  test "authenticate_by_api_key returns nil with invalid key" do
    @user.generate_api_key
    
    authenticated_user = User.authenticate_by_api_key("invalid_key_12345")
    
    assert_nil authenticated_user
  end

  test "authenticate_by_api_key returns nil with blank key" do
    assert_nil User.authenticate_by_api_key("")
    assert_nil User.authenticate_by_api_key(nil)
  end

  test "api_key_present? returns true when API key exists" do
    @user.generate_api_key
    
    assert @user.api_key_present?
  end

  test "api_key_present? returns false when no API key" do
    assert_not @user.api_key_present?
  end

  test "revoke_api_key removes API key data" do
    @user.generate_api_key
    assert @user.api_key_present?
    
    @user.revoke_api_key
    @user.reload
    
    assert_not @user.api_key_present?
    assert_nil @user.api_key_digest
    assert_nil @user.api_key_created_at
  end

  test "generating new API key replaces old one" do
    first_key = @user.generate_api_key
    first_digest = @user.api_key_digest
    
    sleep 0.01 # Ensure timestamp difference
    
    second_key = @user.generate_api_key
    second_digest = @user.api_key_digest
    
    assert_not_equal first_key, second_key
    assert_not_equal first_digest, second_digest
    
    # Old key should no longer work
    assert_nil User.authenticate_by_api_key(first_key)
    
    # New key should work
    assert_not_nil User.authenticate_by_api_key(second_key)
  end
end
