class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  
  # GET /transactions or /transactions.json
  def index
    @q = Transaction.ransack(params[:q])

    @transactions = @q.result(distinct: true).joins(user_tanda: :user).where(user_tandas: { user_id: current_user.id }).order(:date).page(params[:page]).per(5)
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @user_tandas = current_user.user_tandas
  end

  # GET /transactions/1/edit
  def edit
    @user_tandas = current_user.user_tandas
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    user_tanda = current_user.user_tandas.find_by(id: @transaction.user_tanda_id)

    respond_to do |format|
      if user_tanda && @transaction.save
        format.html { redirect_to transaction_url(@transaction), notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        @user_tandas = current_user.user_tandas
        @transaction.errors.add(:user_tanda_id, "is invalid") unless user_tanda
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
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

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:user_tanda_id, :amount, :date, :description, :transaction_type)
    end
end
