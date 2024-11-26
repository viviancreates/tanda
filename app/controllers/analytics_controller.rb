class AnalyticsController < ApplicationController
  def index
    @user_tandas = current_user.user_tandas.includes(:tanda)
    @charts_data = {}

    @user_tandas.each do |user_tanda|
      tanda = user_tanda.tanda
      user_contributions = tanda.user_tandas
        .joins(:transactions) 
        .joins(:user)
        .group('users.username')
        .sum('transactions.amount')

      total_contributions = user_contributions.values.sum
      goal_amount = tanda.goal_amount
      remaining_goal = [goal_amount - total_contributions, 0].max

      @charts_data[tanda.name] = {
        user_data: user_contributions,
        total: total_contributions,
        goal: goal_amount,
        remaining_goal: remaining_goal
      }
    end
    @user_contribution_line = current_user.transactions.group_by_day(:date).sum(:amount)
  end
  
end
