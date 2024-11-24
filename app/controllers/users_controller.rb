class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params.fetch(:username))
    @tandas = @user.tandas
    @transactions = @user.transactions

    if @user.nil?
      redirect_to root_path, alert: "User not found."
    end

    @connections = User.joins(:tandas)
                       .where(tandas: { id: @tandas.pluck(:id) })
                       .where.not(id: @user.id)
                       .distinct
  end
end
