class UsersController < ApplicationController
  before_action :configure_coinbase, only: [:create_wallet, :fund_wallet, :transfer]

  def wallet
  @user = current_user
  end

  def create_wallet
    wallet = Coinbase::Wallet.create
  
    if wallet
      # Export and store the complete wallet data
      current_user.update(wallet_data: wallet.export.to_hash, balance: 0)
      notice = "Wallet created successfully!"
    else
      alert = "Failed to create wallet."
    end
  
    redirect_to user_wallet_path(current_user.username), notice: notice, alert: alert
  end
 
  def fund_wallet
    if current_user.wallet_data.present? # Check if wallet data exists
      begin
        # Recreate the wallet object
        wallet_data = Coinbase::Wallet::Data.new(
          wallet_id: current_user.wallet_data["wallet_id"],
          seed: current_user.wallet_data["seed"]
        )
        wallet = Coinbase::Wallet.import(wallet_data)
  
        # Request faucet funds
        faucet_tx = wallet.faucet.wait! # Automatically funds the wallet with a fixed testnet amount
  
        # Fetch the updated balance
        balance = wallet.balance(:eth)
        current_user.update(balance: balance.to_f)
  
        notice = "Wallet funded successfully! New Balance: #{balance.to_f} ETH"
      rescue StandardError => e
        Rails.logger.error "Error funding wallet: #{e.message}"
        alert = "An error occurred while funding the wallet. Please try again."
      end
    else
      alert = "No wallet found. Please create a wallet first."
    end
  
    redirect_to user_wallet_path(current_user.username),  notice: notice, alert: alert
  end
  
  
  def transfer
    if current_user.wallet_data.present?
      # Extract wallet data
      wallet_id = current_user.wallet_data['wallet_id']
      seed = current_user.wallet_data['seed']
  
      # Initialize Coinbase::Wallet::Data
      wallet_data = Coinbase::Wallet::Data.new(wallet_id: wallet_id, seed: seed)
  
      # Import wallet
      wallet = Coinbase::Wallet.import(wallet_data)
  
      begin
        # Initiate the transfer
        transfer = wallet.transfer(params[:amount].to_f, params[:currency].to_sym, params[:recipient_address])
        transfer.wait! # Wait for the transaction to settle
  
        # Fetch the updated balance
        updated_balance = wallet.balance(params[:currency].to_sym)
  
        # Update the user's balance in the database
        current_user.update(balance: updated_balance.to_f)
  
        notice = "Transfer successful! Your updated balance is #{updated_balance.to_f} #{params[:currency].upcase}."
      rescue StandardError => e
        Rails.logger.error "Error during transfer: #{e.message}"
        alert = "Transfer failed: #{e.message}"
      end
    else
      alert = "You need to create a wallet before making transfers."
    end
  
    redirect_to user_wallet_path(current_user.username),  notice: notice, alert: alert
  end
  

  def friends
    @friends = fetch_accepted_friends.page(params[:page]).per(10)
  end

  def show
    @user = User.find_by(username: params[:username])


    if @user.nil?
      redirect_to root_path, alert: "User not found."
    else
      @tandas = @user.tandas.page(params[:page]).per(5)
      @transactions = @user.transactions.page(params[:page]).per(5)

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
