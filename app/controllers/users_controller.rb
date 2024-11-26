class UsersController < ApplicationController
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
end
