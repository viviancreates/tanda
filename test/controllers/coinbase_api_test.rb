require 'test_helper'
require 'minitest/mock'

class CoinbaseAPITest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Ensure Devise helpers are available

  def test_create_wallet
    # Create a user for the test
    user = User.create!(username: 'testuser', email: 'test@example.com', password: 'password')

    # Sign in the user
    sign_in user

    # Mock the wallet creation process
    wallet_mock = Minitest::Mock.new
    wallet_mock.expect(:export, { 'wallet_id' => 'mock_wallet_id', 'seed' => 'mock_seed' })

    # Stub the Coinbase::Wallet.create method
    Coinbase::Wallet.stub :create, wallet_mock do
      # Simulate a POST request to create_wallet
      post create_wallet_path(user.id)
    end

    # Assertions to validate behavior
    assert_response :redirect
    assert_redirected_to user_wallet_path(user.username)

    # Check the flash notice
    assert_equal "Wallet created successfully!", flash[:notice]
  end
end
