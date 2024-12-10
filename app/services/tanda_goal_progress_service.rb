class TandaGoalProgressService
  def initialize(tanda)
    @tanda = tanda
  end

  def call
    total_contributions = @tanda.transactions.sum(:amount)
    progress_percentage = calculate_percentage(total_contributions, @tanda.goal_amount)

    {
      tanda_name: @tanda.name,
      total_contributions: total_contributions,
      goal_amount: @tanda.goal_amount,
      progress_percentage: progress_percentage,
    }
  end

  private

  def calculate_percentage(current, total)
    return 0 if total.to_f.zero?
    ((current.to_f / total.to_f) * 100).round(2)
  end
end
