class UsersController < ApplicationController
  def friends
    @friends = fetch_accepted_friends
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

  def search
    if params[:username].present?
      @users = User.where("username LIKE ?", "%#{params[:username]}%").where.not(id: current_user.id)
    else
      @users = []
    end
  end

  private

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
end
