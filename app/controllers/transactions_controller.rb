class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  def index
    @q = Transaction.ransack(params[:q])

    @transactions = @q.result(distinct: true).joins(user_tanda: :user).where(user_tandas: { user_id: current_user.id }).order(:date).page(params[:page]).per(5)
  end

  def show
  end

  def new
    @transaction = Transaction.new
    @user_tandas = current_user.user_tandas
  end

  def edit
    @user_tandas = current_user.user_tandas
  end

  def create
    @transaction = Transaction.new(transaction_params)
    user_tanda = current_user.user_tandas.find_by(id: @transaction.user_tanda_id)

    respond_to do |format|
      if user_tanda && @transaction.save
        format.html { redirect_to transaction_url(@transaction), notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
        format.js
      else
        @user_tandas = current_user.user_tandas
        @transaction.errors.add(:user_tanda_id, "is invalid") unless user_tanda
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    user_tanda = current_user.user_tandas.find_by(id: @transaction.user_tanda_id)

    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transaction_url(@transaction), notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:user_tanda_id, :amount, :date, :description, :transaction_type)
  end
end
