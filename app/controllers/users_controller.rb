class UsersController < ApplicationController
  before_action :configure_coinbase, only: [:create_wallet, :fund_wallet]

  def create_wallet
    wallet = Coinbase::Wallet.create
  
    if wallet
      # Export and store the complete wallet data
      current_user.update(wallet_data: wallet.export.to_hash, balance: 0)
      flash[:success] = "Wallet created successfully!"
    else
      flash[:error] = "Failed to create wallet."
    end
  
    redirect_to user_path(current_user.username)
  end
 
  def fund_wallet
    if current_user.wallet_data.present?
      begin
        # Create a Coinbase::Wallet::Data object from stored wallet_data
        wallet_data = Coinbase::Wallet::Data.new(
          wallet_id: current_user.wallet_data["wallet_id"],
          seed: current_user.wallet_data["seed"]
        )
  
        # Import the wallet using the Wallet::Data object
        wallet = Coinbase::Wallet.import(wallet_data)
  
        # Fund the wallet
        faucet_tx = wallet.faucet.wait!
  
        flash[:success] = "Wallet funded successfully!" if faucet_tx
      rescue StandardError => e
        Rails.logger.error "Error funding wallet: #{e.message}"
        flash[:error] = "An error occurred while funding the wallet: #{e.message}"
      end
    else
      flash[:error] = "No wallet found. Please create a wallet first."
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
