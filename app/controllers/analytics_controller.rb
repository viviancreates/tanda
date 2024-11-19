class AnalyticsController < ApplicationController
  def index
    @amount_per_user = Transaction.group(:user_tanda_id).sum(:amount)
  end
end
