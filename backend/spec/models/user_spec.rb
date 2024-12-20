RSpec.describe User, type: :model do
  # Test for validations
  
  # Testing if a user with valid attributes (email, first name, last name, and password) is valid
  it "is valid with valid attributes" do
    user = User.new(
      email: "user@example.com",
      first_name: "John",
      last_name: "Doe",
      password: "password123",
      password_confirmation: "password123"
    )
    expect(user).to be_valid  # This test should pass because all required fields are provided correctly
  end

  # Testing if a user is invalid without an email
  it "is invalid without an email" do
    user = User.new(first_name: "John", last_name: "Doe", password: "password123")
    expect(user).to_not be_valid  # This test should fail because the email is missing, and it's a required field
  end

  # Testing if a user is invalid without a first name
  it "is invalid without a first name" do
    user = User.new(email: "user@example.com", last_name: "Doe", password: "password123")
    expect(user).to_not be_valid  # This test should fail because the first name is missing, and it's a required field
  end

  # Testing if a user is invalid without a last name
  it "is invalid without a last name" do
    user = User.new(email: "user@example.com", first_name: "John", password: "password123")
    expect(user).to_not be_valid  # This test should fail because the last name is missing, and it's a required field
  end

  # Testing if the email is unique (the user is invalid if email is not unique)
  it "is invalid if email is not unique" do
    # Create a user with the same email as the one being tested
    User.create!(
      email: "user@example.com", first_name: "John", last_name: "Doe", password: "password123", password_confirmation: "password123"
    )
    user = User.new(
      email: "user@example.com", first_name: "Jane", last_name: "Doe", password: "password123", password_confirmation: "password123"
    )
    expect(user).to_not be_valid  # This test should fail because the email is not unique, and email uniqueness is a validation rule
  end

  # Test for the 'admin?' method
  describe "#admin?" do
    # Testing if the 'admin?' method returns true for an admin user
    it "returns true if user is an admin" do
      user = User.new(email: "admin@example.com", first_name: "Admin", last_name: "User", password: "password123", password_confirmation: "password123", is_admin: true)
      expect(user.admin?).to be(true)  # This test should pass because the user is marked as an admin
    end

    # Testing if the 'admin?' method returns false for a non-admin user
    it "returns false if user is not an admin" do
      user = User.new(email: "user@example.com", first_name: "Regular", last_name: "User", password: "password123", password_confirmation: "password123", is_admin: false)
      expect(user.admin?).to be(false)  # This test should pass because the user is not an admin
    end
  end

  # Test for association with bookings
  describe "associations" do
    # Testing the association between User and Booking (a user has many bookings)
    it "has many bookings" do
      association = described_class.reflect_on_association(:bookings)
      expect(association.macro).to eq(:has_many)  # This test should pass because a user should have many bookings
    end
  end
end
