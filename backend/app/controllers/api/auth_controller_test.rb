# test/controllers/api/auth_controller_test.rb
require 'test_helper'

class Api::AuthControllerTest < ActionDispatch::IntegrationTest
  # Test the signup action
  test "should sign up user" do
    post api_auth_signup_url, params: { auth: { email: "testuser@example.com", password: "password123", first_name: "John", last_name: "Doe" } }
    
    assert_response :created
    json_response = JSON.parse(@response.body)
    assert json_response["message"], "Account created successfully"
    assert json_response["token"]
  end

  test "should not sign up user with invalid params" do
    post api_auth_signup_url, params: { auth: { email: "", password: "password123", first_name: "John", last_name: "Doe" } }
    
    assert_response :unprocessable_entity
    json_response = JSON.parse(@response.body)
    assert json_response["error"]
  end

  # Test the login action
  test "should log in user with valid credentials" do
    # Create a user first
    user = User.create!(email: "testuser@example.com", password: "password123", first_name: "John", last_name: "Doe")
    
    post api_auth_login_url, params: { email: "testuser@example.com", password: "password123" }

    assert_response :ok
    json_response = JSON.parse(@response.body)
    assert json_response["message"], "Login successful"
    assert json_response["token"]
    assert json_response["is_admin"]
  end

  test "should not log in with invalid credentials" do
    post api_auth_login_url, params: { email: "testuser@example.com", password: "wrongpassword" }
    
    assert_response :unauthorized
    json_response = JSON.parse(@response.body)
    assert json_response["error"], "Invalid email or password"
  end
end
