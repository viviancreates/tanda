require 'test_helper'
require 'minitest/mock'

class TandaFlowsTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      username: 'testuser',
      email: 'test@example.com',
      password: 'password',
      first_name: 'Test'
    )
    @friend = User.create!(
      username: 'frienduser',
      email: 'friend@example.com',
      password: 'password',
      first_name: 'Friend'
    )
    sign_in @user

    # Create and accept a friend request
    post follow_requests_path, params: { follow_request: { recipient_id: @friend.id } }
    follow_request = FollowRequest.find_by(sender_id: @user.id, recipient_id: @friend.id)
    follow_request.update!(status: 'accepted')
  end

  test "create profile and add a friend" do
    # Verify profile creation
    assert @user.persisted?
    assert_equal 'testuser', @user.username

    # Verify friend association
    follow_request = FollowRequest.find_by(sender_id: @user.id, recipient_id: @friend.id)
    assert follow_request.present?
    assert_equal 'accepted', follow_request.status
  end

  test "create tanda and add participant" do
    # Create tanda
    post tandas_path, params: { tanda: { name: 'Test Tanda', goal_amount: 1000, due_date: Date.today + 7.days, participant_ids: [@friend.id] } }
    tanda = Tanda.find_by(name: 'Test Tanda')
    assert tanda.present?, "Tanda should be created"
    assert_equal 'Test Tanda', tanda.name

    # Verify participant added
    user_tanda = UserTanda.find_by(user_id: @friend.id, tanda_id: tanda.id)
    assert user_tanda.present?, "UserTanda record should be created for the friend"
  end

  test "add transaction to tanda" do
    # Create tanda
    tanda = Tanda.create!(name: 'Test Tanda', goal_amount: 1000, due_date: Date.today + 7.days, creator: @user)
    UserTanda.create!(user: @user, tanda: tanda)

    # Add transaction
    post transactions_path, params: {
      transaction: {
        user_tanda_id: UserTanda.find_by(user: @user, tanda: tanda).id,
        amount: 100,
        description: 'Initial payment',
        transaction_type: 'credit',
        date: Date.today
      }
    }
    transaction = Transaction.find_by(user_tanda_id: UserTanda.find_by(user: @user, tanda: tanda).id)
    assert transaction.present?, "Transaction should be created"
    assert_equal 100, transaction.amount
    assert_equal 'Initial payment', transaction.description
  end
end
