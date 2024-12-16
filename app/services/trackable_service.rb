class TrackableService
  def initialize(trackable)
    @trackable = trackable
  end

  def track_action(action)
    message = "Tracking action: #{action.capitalize} for #{@trackable.trackable_type} ##{@trackable.trackable_id}"
    Rails.logger.info message
    message
  end
end
