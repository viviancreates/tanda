class Task < ApplicationRecord
  belongs_to :user
  after_create :send_task_created_email

  private

  def send_task_created_email
    TaskMailer.task_created(self).deliver_now
  end
end
