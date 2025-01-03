class TandasController < ApplicationController
  before_action :set_tanda, only: %i[ show edit update destroy ]

  def index
    @breadcrumbs = [
      { content: "Tandas", href: tandas_path }
    ]
    @q = Tanda.ransack(params[:q])
    @tandas = @q.result(distinct: true).joins(:user_tandas).where(user_tandas: { user_id: current_user.id }).order(:created_at).page(params[:page]).per(5)
  end

  def show
    @breadcrumbs = [
      { content: "Tandas", href: tandas_path },
      { content: @tanda.name }
    ]

    @current_amount = Transaction.joins(user_tanda: :tanda)
      .where(tandas: { id: @tanda.id })
      .sum(:amount)

    @progress_percentage = calculate_percentage(@current_amount, @tanda.goal_amount)

    # Generate greeting
    @greeting = TandaGreetingService.new(current_user, @tanda, @progress_percentage).call
  end

  def new
    @breadcrumbs = [
      { content: "Tandas", href: tandas_path },
      { content: "New" }
    ]

    @tanda = Tanda.new
    @friends = fetch_accepted_friends
  end

  def edit
    @breadcrumbs = [
      { content: "Tandas", href: tandas_path },
      { content: @tanda.name, href: tanda_path(@tanda) },
      { content: "Edit" }
    ]

    @friends = fetch_accepted_friends
  end

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
        @friends = fetch_accepted_friends
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tanda.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def destroy
    @tanda.destroy!

    respond_to do |format|
      format.html { redirect_to tandas_url, notice: "Tanda was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def calculate_percentage(current, total)
    return 0 if total.to_f.zero?
    ((current.to_f / total.to_f) * 100).round(2)
  end

  def set_tanda
    @tanda = Tanda.find(params[:id])
  end

  def tanda_params
    params.require(:tanda).permit(:goal_amount, :creator_id, :name, :due_date, :creator_wallet)
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

  def set_breadcrumbs
    @breadcrumbs ||= [
      { content: "Home", href: root_path }
    ]
  end
end
