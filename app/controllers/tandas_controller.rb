class TandasController < ApplicationController
  before_action :set_tanda, only: %i[ show edit update destroy ]
  
  def invite_user
    @tanda = Tanda.find(params[:id])
    user = User.find_by(username: params[:username])
  
    respond_to do |format|
      if user.nil?
        format.html { redirect_to tanda_url(@tanda), alert: "User not found." }
        format.json { render json: { error: "User not found." }, status: :not_found }
      elsif @tanda.users.include?(user)
        format.html { redirect_to tanda_url(@tanda), alert: "User is already in this Tanda." }
        format.json { render json: { error: "User is already in this Tanda." }, status: :unprocessable_entity }
      else
        @tanda.invitations.create(sender_id: current_user.id, receiver_id: user.id, status: "pending")
        format.html { redirect_to tanda_url(@tanda), notice: "Invitation sent!" }
        format.json { render json: { message: "Invitation sent!" }, status: :created }
      end
    end
  end

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
  end

  # GET /tandas/1/edit
  def edit
  end

  # POST /tandas or /tandas.json
  def create
    @tanda = Tanda.new(tanda_params)
    @tanda.creator_id = current_user.id

    respond_to do |format|
      if @tanda.save
        UserTanda.create(user_id: current_user.id, tanda_id: @tanda.id)

        params[:participants]&.each do |user_id|
        UserTanda.create(user_id: current_user.id, tanda_id: @tanda.id)
        end
        format.html { redirect_to tanda_url(@tanda), notice: "Tanda was successfully created." }
        format.json { render :show, status: :created, location: @tanda }
      else
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

  def tanda_params
    params.require(:tanda).permit(:goal_amount, :name, :due_date, participant_ids: [])
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
end
