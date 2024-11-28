class WalletsController < ApplicationController
  # This action will create a new wallet
  def create
    Coinbase.configure do |config|
      config.api_key_name = ENV['COINBASE_API_KEY_NAME']
      config.api_key_private_key = ENV['COINBASE_API_KEY_PRIVATE_KEY']
    end

    # Create a new wallet
    @wallet = Coinbase::Wallet.create

    # Handle the success/failure of wallet creation
    if @wallet
      flash[:success] = "Wallet created successfully! Address: #{@wallet.default_address}"
      redirect_to wallet_path(@wallet.id) # Redirect to the wallet details page
    else
      flash[:error] = "Failed to create wallet."
      render :new
    end
  end

  # This action will show the wallet details
  def show
    @wallet = Coinbase::Wallet.find(params[:id])
  end

  # This action will fund the wallet with testnet ETH
  def fund
    @wallet = Coinbase::Wallet.find(params[:id])

    # Fund the wallet using the faucet method (testnet)
    faucet_tx = @wallet.faucet
    faucet_tx.wait! # Wait until the transaction is complete

    # Handle success/failure
    if faucet_tx
      flash[:success] = "Wallet funded successfully!"
    else
      flash[:error] = "Failed to fund wallet."
    end
    redirect_to wallet_path(@wallet.id)
  end

  # This action will handle transfers between two wallets
  def transfer
    @from_wallet = Coinbase::Wallet.find(params[:from_wallet_id])
    @to_wallet = Coinbase::Wallet.find(params[:to_wallet_id])
    amount = params[:amount].to_f

    # Transfer funds from one wallet to another
    transfer = @from_wallet.transfer(amount, :eth, @to_wallet).wait!

    # Handle success/failure
    if transfer
      flash[:success] = "Transfer completed successfully!"
    else
      flash[:error] = "Failed to complete transfer."
    end

    redirect_to wallet_path(@from_wallet.id)
  end

  private

  # Strong parameters for the wallet
  def wallet_params
    params.require(:wallet).permit(:amount, :from_wallet_id, :to_wallet_id)
  end
end
