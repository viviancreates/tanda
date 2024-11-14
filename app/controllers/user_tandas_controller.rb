class UserTandasController < ApplicationController
  before_action :set_user_tanda, only: %i[ show edit update destroy ]

  # GET /user_tandas or /user_tandas.json
  def index
    @user_tandas = UserTanda.all
  end

  # GET /user_tandas/1 or /user_tandas/1.json
  def show
  end

  # GET /user_tandas/new
  def new
    @user_tanda = UserTanda.new
  end

  # GET /user_tandas/1/edit
  def edit
  end

  # POST /user_tandas or /user_tandas.json
  def create
    @user_tanda = UserTanda.new(user_tanda_params)

    respond_to do |format|
      if @user_tanda.save
        format.html { redirect_to user_tanda_url(@user_tanda), notice: "User tanda was successfully created." }
        format.json { render :show, status: :created, location: @user_tanda }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_tanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_tandas/1 or /user_tandas/1.json
  def update
    respond_to do |format|
      if @user_tanda.update(user_tanda_params)
        format.html { redirect_to user_tanda_url(@user_tanda), notice: "User tanda was successfully updated." }
        format.json { render :show, status: :ok, location: @user_tanda }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_tanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_tandas/1 or /user_tandas/1.json
  def destroy
    @user_tanda.destroy!

    respond_to do |format|
      format.html { redirect_to user_tandas_url, notice: "User tanda was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_tanda
      @user_tanda = UserTanda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_tanda_params
      params.require(:user_tanda).permit(:goal_id, :user_id)
    end
end
