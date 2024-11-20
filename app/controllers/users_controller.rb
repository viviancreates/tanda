class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params.fetch(:username))
    @tandas = @user.tandas
    @transactions = @user.transactions
  end
end
