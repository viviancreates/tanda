class AnalyticsController < ApplicationController
  def index
    @user = current_user
    @user_tandas = current_user.user_tandas.includes(:tanda).where.not(tanda: nil)
    @charts_data = {}
    @user_total_contributions = current_user.transactions.sum(:amount)

    pastel_colors = [
      "#FFB3BA",
      "#FFDFBA",
      "#FFFFBA",
      "#B9FBC2",
      "#BAE1FF",
      "#AEC6CF",
      "#D5AAFF",
      "#FFCCF9",
      "#FFABAB",
      "#FFC3A0",
    ]

    @user_tandas.each do |user_tanda|
      tanda = user_tanda.tanda
      next if tanda.nil?
      user_contributions = tanda.user_tandas
        .joins(:transactions)
        .joins(:user)
        .group("users.username")
        .sum("transactions.amount")

      total_contributions = user_contributions.values.sum
      goal_amount = tanda.goal_amount
      remaining_goal = [goal_amount - total_contributions, 0].max

      chart_colors = pastel_colors.sample(pastel_colors.length)

      @charts_data[tanda.name] = {
        user_data: user_contributions,
        total: total_contributions,
        goal: goal_amount,
        remaining_goal: remaining_goal,
        colors: chart_colors,
      }
    end
    @user_contribution_line = current_user.transactions.group_by_day(:date).sum(:amount)

   @activities = [
      TrackableService.new(Tanda.first).track_action("created"),
      TrackableService.new(Transaction.first).track_action("updated")
    ]
  end
end
