require 'test_helper'
require 'minitest/mock'
require 'ostruct'

class CoinbaseAPITest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      username: 'testuser',
      email: 'test@example.com',
      password: 'password',
      first_name: 'Test',
      wallet_data: { 'wallet_id' => 'mock_wallet_id', 'seed' => 'mock_seed' }
    )
    sign_in @user
  end

  def test_create_wallet
    # Mock the wallet creation process
    wallet_mock = Minitest::Mock.new
    wallet_mock.expect(:export, { 'wallet_id' => 'mock_wallet_id', 'seed' => 'mock_seed' })

    # Stub the Coinbase::Wallet.create method
    Coinbase::Wallet.stub :create, wallet_mock do
      post create_wallet_path(@user.id)
    end

    assert_redirected_to user_wallet_path(@user.username)
    assert_equal 'Wallet created successfully!', flash[:notice]
    wallet_mock.verify
  end

  def test_fund_wallet
    # Set up mock wallet data for the user
    @user.update(wallet_data: { 'wallet_id' => 'mock_wallet_id', 'seed' => 'mock_seed' })

    # Mock the wallet import and faucet funding
    wallet_mock = Minitest::Mock.new
    wallet_mock.expect(:faucet, OpenStruct.new(wait!: OpenStruct.new(transaction_hash: 'mock_tx_hash', transaction_link: 'mock_tx_link')))
    wallet_mock.expect(:balance, 1.5, [:eth])

    Coinbase::Wallet.stub :import, wallet_mock do
      post fund_wallet_path(@user.id)
    end

    assert_redirected_to user_wallet_path(@user.username)
    assert_match /Wallet funded successfully!/, flash[:notice]
    wallet_mock.verify
  end

  def test_transfer_funds
    wallet_mock = Minitest::Mock.new
    wallet_mock.expect(:transfer, OpenStruct.new(transaction_link: 'mock_transfer_link'), [1.0, :eth, 'recipient_wallet_address'])
    wallet_mock.expect(:balance, 0.5, [:eth])
  
    Coinbase::Wallet.stub :import, wallet_mock do
      # Create a UserTanda before transfer
      tanda = Tanda.create!(name: 'Test Tanda', goal_amount: 1000, due_date: Date.today + 7.days, creator: @user)
      user_tanda = UserTanda.create!(user: @user, tanda: tanda)
  
      post transfer_wallet_path(@user.id, format: :js), params: {
        amount: 1.0,
        currency: 'eth',
        recipient_address: 'recipient_wallet_address',
        tanda_id: tanda.id
      }
    end
  
    assert_response :success
    transaction = Transaction.last
    assert transaction.present?, "Transaction should be created"
    assert_equal 1.0, transaction.amount
    assert_equal 'Transfer to recipient_wallet_address', transaction.description
    wallet_mock.verify
  end
end  