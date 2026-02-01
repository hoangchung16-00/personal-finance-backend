require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
  end

  test "should not save category without name" do
    category = @user.categories.build
    assert_not category.save, "Saved the category without a name"
  end

  test "should save category with valid attributes" do
    category = @user.categories.build(name: "Groceries")
    assert category.save, "Failed to save the category with valid attributes"
  end

  test "should not allow duplicate category names for same user" do
    @user.categories.create!(name: "Groceries")
    category = @user.categories.build(name: "Groceries")
    assert_not category.save, "Saved duplicate category for the same user"
  end

  test "should allow same category name for different users" do
    user2 = User.create!(email: "user2@example.com", first_name: "Jane", last_name: "Doe")
    @user.categories.create!(name: "Groceries")
    category = user2.categories.build(name: "Groceries")
    assert category.save, "Failed to save same category name for different user"
  end
end
