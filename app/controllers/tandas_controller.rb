class TandasController < ApplicationController
  before_action :set_tanda, only: %i[ show edit update destroy ]
  
  # GET /tandas or /tandas.json
  def index
    @tandas = Tanda.all
  end

  # GET /tandas/1 or /tandas/1.json
  def show
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

    respond_to do |format|
      if @tanda.save
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
