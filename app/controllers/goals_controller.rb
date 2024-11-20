def chart_data
  render json: Transaction.group_by_day(:created_at).count
end
