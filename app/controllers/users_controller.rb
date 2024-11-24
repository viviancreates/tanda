class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params.fetch(:username))
    @tandas = @user.tandas
    @transactions = @user.transactions

    if @user.nil?
      redirect_to root_path, alert: "User not found."
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User created successfully with an avatar!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar)  # Ensure :avatar is allowed
  end
end
