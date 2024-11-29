class TandasController < ApplicationController
  before_action :set_tanda, only: %i[ show edit update destroy link_wallet ]
  
  # GET /tandas or /tandas.json
  def index
    @tandas = Tanda.joins(:user_tandas).where(user_tandas: { user_id: current_user.id })
  end

  # GET /tandas/1 or /tandas/1.json
  def show
    @current_amount = Transaction.joins(user_tanda: :tanda)
    .where(tandas: { id: @tanda.id })
    .sum(:amount)
  end

  # GET /tandas/new
  def new
    @tanda = Tanda.new
    @friends = fetch_accepted_friends
  end

  # GET /tandas/1/edit
  def edit
    @friends = fetch_accepted_friends
  end

  # POST /tandas or /tandas.json
  def create
    @tanda = Tanda.new(tanda_params)
    @tanda.creator_id = current_user.id
    @tanda.creator_wallet = current_user.default_address

    respond_to do |format|
      if @tanda.save

        UserTanda.create(user_id: current_user.id, tanda_id: @tanda.id)
      
        if params[:tanda][:participant_ids].present?
          params[:tanda][:participant_ids].each do |participant_id|
            UserTanda.create(user_id: participant_id, tanda_id: @tanda.id)
          end
        end

  
        format.html { redirect_to tanda_url(@tanda), notice: "Tanda was successfully created." }
        format.json { render :show, status: :created, location: @tanda }
      else
        @friends = current_user.accepted_friends
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tandas/1 or /tandas/1.json
  def update
    respond_to do |format|
      if @tanda.update(tanda_params)
        format.html { redirect_to tanda_url(@tanda), notice: "Tanda was successfully updated." }
        format.json { render :show, status: :ok, location: @tanda }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tandas/1 or /tandas/1.json
  def destroy
    @tanda.destroy!

    respond_to do |format|
      format.html { redirect_to tandas_url, notice: "Tanda was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def link_wallet
    if current_user.default_address.present?
      @tanda.update(creator_wallet: current_user.default_address)
      flash[:success] = "Wallet linked successfully to the tanda!"
    else
      flash[:error] = "No wallet found. Please create a wallet first."
    end
    redirect_to tanda_path(@tanda)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tanda
      @tanda = Tanda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tanda_params
      params.require(:tanda).permit(:goal_amount, :creator_id, :name, :due_date)
    end

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
end
