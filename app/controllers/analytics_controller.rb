class AnalyticsController < ApplicationController
  def index
    @user_tandas = UserTanda.all
    @charts_data = {}

    @user_tandas.each do |user_tanda|
      tanda = user_tanda.tanda
      @charts_data[tanda.name] = tanda.user_tandas
        .joins(:transactions) 
        .joins(:user)
        .group('users.username')
        .pluck('users.username', 'SUM(transactions.amount)')
    end
  end
end
