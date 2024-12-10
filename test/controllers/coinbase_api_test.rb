require "test_helper"
require "minitest/mock"
require "ostruct"

class CoinbaseAPITest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "password",
      first_name: "Test",
      wallet_data: { "wallet_id" => "mock_wallet_id", "seed" => "mock_seed" },
    )
    sign_in @user
  end

  def test_create_wallet
    # Mock the wallet creation process
    wallet_mock = Minitest::Mock.new
    wallet_mock.expect(:export, { "wallet_id" => "mock_wallet_id", "seed" => "mock_seed" })

    # Stub the Coinbase::Wallet.create method
    Coinbase::Wallet.stub :create, wallet_mock do
      post create_wallet_path(@user.id)
    end

    assert_redirected_to user_wallet_path(@user.username)
    assert_equal "Wallet created successfully!", flash[:notice]
    wallet_mock.verify
  end

  def test_fund_wallet
    # Set up mock wallet data for the user
    @user.update(wallet_data: { "wallet_id" => "mock_wallet_id", "seed" => "mock_seed" })

    # Mock the wallet import and faucet funding
    wallet_mock = Minitest::Mock.new
    wallet_mock.expect(:faucet, OpenStruct.new(wait!: OpenStruct.new(transaction_hash: "mock_tx_hash", transaction_link: "mock_tx_link")))
    wallet_mock.expect(:balance, 1.5, [:eth])

    Coinbase::Wallet.stub :import, wallet_mock do
      post fund_wallet_path(@user.id)
    end

    assert_redirected_to user_wallet_path(@user.username)
    assert_match /Wallet funded successfully!/, flash[:notice]
    wallet_mock.verify
  end
end
