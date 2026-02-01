require "test_helper"

class Api::V1::CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", first_name: "John", last_name: "Doe")
    @api_key = @user.generate_api_key
    @category = @user.categories.create!(name: "Groceries")
  end

  test "should get index" do
    get api_v1_categories_url, headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
  end

  test "should show category" do
    get api_v1_category_url(@category), headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @category.name, json_response["name"]
  end

  test "should create category" do
    assert_difference("Category.count") do
      post api_v1_categories_url, headers: { "Authorization" => "Bearer #{@api_key}" }, params: {
        category: { name: "Utilities" }
      }, as: :json
    end
    assert_response :created
  end

  test "should update category" do
    patch api_v1_category_url(@category), headers: { "Authorization" => "Bearer #{@api_key}" }, params: {
      category: { name: "Food & Groceries" }
    }, as: :json
    assert_response :success
    @category.reload
    assert_equal "Food & Groceries", @category.name
  end

  test "should destroy category" do
    assert_difference("Category.count", -1) do
      delete api_v1_category_url(@category), headers: { "Authorization" => "Bearer #{@api_key}" }, as: :json
    end
    assert_response :no_content
  end
end
