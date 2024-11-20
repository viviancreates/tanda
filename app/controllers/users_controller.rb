class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params.fetch(:username))
    @tandas = @user.tandas
    @transactions = @user.transactions

    if @user.nil?
      redirect_to root_path, alert: "User not found."
    end
  end
end
