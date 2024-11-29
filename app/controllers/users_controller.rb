class UsersController < ApplicationController
  before_action :configure_coinbase, only: [:create_wallet, :fund_wallet]

  def create_wallet
    wallet = Coinbase::Wallet.create
  
    if wallet
      current_user.update(default_address: wallet.default_address.id, balance: 0)
      flash[:success] = "Wallet created successfully!"
    else
      flash[:error] = "Failed to create wallet."
    end
  
    redirect_to user_path(current_user.username)
  end  

  def fund_wallet
    wallet = Coinbase::Wallet.create # Create a new wallet each time
    faucet_tx = wallet.faucet.wait!
  
    if faucet_tx
      flash[:success] = "Wallet funded successfully!"
    else
      flash[:error] = "Failed to fund wallet."
    end
  
    redirect_to user_path(current_user.username)
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

  def configure_coinbase
    Coinbase.configure do |config|
      config.api_key_name = ENV['API_KEY_NAME']
      config.api_key_private_key = ENV['API_KEY_PRIVATE_KEY']
    end
  end
end
