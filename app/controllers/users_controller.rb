class UsersController < ApplicationController
  def search
    if params[:query].present?
      @users = User.where("username ILIKE ?", "%#{params[:query]}%").limit(10)
    else
      @users = nil
    end

    respond_to do |format|
      format.html # This can render a search page if needed
      format.json { render partial: 'users/search_results', locals: { users: @users } }
    end
  end
end
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
end
