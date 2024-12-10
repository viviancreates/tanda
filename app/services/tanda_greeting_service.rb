# app/services/tanda_greeting_service.rb
class TandaGreetingService
  def initialize(user, tanda, progress_percentage)
    @user = user
    @tanda = tanda
    @progress_percentage = progress_percentage
  end

  def call
    generate_greeting
  end

  private

  def generate_greeting
    if @progress_percentage >= 100
      "Hi #{@user.first_name}, congratulations on completing your Tanda goal!"
    elsif @progress_percentage >= 50
      "Hi #{@user.first_name}, you're doing great! You've reached #{@progress_percentage}% of your Tanda goal."
    elsif @progress_percentage > 0
      "Hi #{@user.first_name}, keep it up! You've made #{@progress_percentage}% progress toward your Tanda goal."
    else
      "Hi #{@user.first_name}, let's get started! Your Tanda goal is waiting for you."
    end
  end
end
