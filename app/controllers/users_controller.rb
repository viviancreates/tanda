class UsersController < ApplicationController
  def create_wallet
    Coinbase.configure do |config|
      config.api_key_name = ENV['COINBASE_API_KEY_NAME']
      config.api_key_private_key = ENV['COINBASE_API_KEY_PRIVATE_KEY']
    end

    wallet = Coinbase::Wallet.create
    if wallet
      current_user.update(default_address: wallet.default_address, balance: 0)
      flash[:success] = "Wallet created successfully!"
    else
      flash[:error] = "Failed to create wallet."
    end
    redirect_to user_path(current_user)

    Rails.logger.info "create_wallet method called"

  end

  def friends
    @friends = fetch_accepted_friends
  end

  def show
    @user = User.find_by(username: params[:username])


    if @user.nil?
      redirect_to root_path, alert: "User not found."
    else
      @tandas = @user.tandas
      @transactions = @user.transactions

      @connections = User.joins(:tandas)
                         .where(tandas: { id: @tandas.pluck(:id) })
                         .where.not(id: @user.id)
                         .distinct
    end
  end

  def search
    if params[:username].present?
      @users = User.where("username LIKE ?", "%#{params[:username]}%").where.not(id: current_user.id)
    else
      @users = []
    end
  end

  private

  def fetch_accepted_friends
    sent_friend_ids = FollowRequest.where(sender_id: current_user.id, status: "accepted").pluck(:recipient_id)
    received_friend_ids = FollowRequest.where(recipient_id: current_user.id, status: "accepted").pluck(:sender_id)
    User.where(id: sent_friend_ids + received_friend_ids)
  end

  def accepted_friends
    sent_friend_ids = FollowRequest.where(sender_id: id, status: "accepted").pluck(:recipient_id)
    received_friend_ids = FollowRequest.where(recipient_id: id, status: "accepted").pluck(:sender_id)
    User.where(id: sent_friend_ids + received_friend_ids).distinct
  end


  # Fund the user's wallet
  def fund_wallet
    if current_user.default_address.present?
      Coinbase.configure do |config|
        config.api_key_name = ENV['COINBASE_API_KEY_NAME']
        config.api_key_private_key = ENV['COINBASE_API_KEY_PRIVATE_KEY']
      end

      wallet = Coinbase::Wallet.find(current_user.default_address)
      faucet_tx = wallet.faucet
      faucet_tx.wait!
      current_user.update(balance: wallet.balance(:eth).amount)
      flash[:success] = "Wallet funded successfully!"
    else
      flash[:error] = "No wallet found. Please create a wallet first."
    end
    redirect_to user_path(current_user)
  end
end
