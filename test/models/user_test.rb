require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new(first_name: "John", last_name: "Doe")
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save user without first name" do
    user = User.new(email: "test@example.com", last_name: "Doe")
    assert_not user.save, "Saved the user without a first name"
  end

  test "should not save user without last name" do
    user = User.new(email: "test@example.com", first_name: "John")
    assert_not user.save, "Saved the user without a last name"
  end

  test "should not save user with invalid email" do
    user = User.new(email: "invalid", first_name: "John", last_name: "Doe")
    assert_not user.save, "Saved the user with invalid email"
  end

  test "should save user with valid attributes" do
    user = User.new(email: "test@example.com", first_name: "John", last_name: "Doe")
    assert user.save, "Failed to save the user with valid attributes"
  end

  test "should not save user with duplicate email" do
    User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
    user = User.new(email: "test@example.com", first_name: "Jane", last_name: "Doe")
    assert_not user.save, "Saved the user with duplicate email"
  end
end
