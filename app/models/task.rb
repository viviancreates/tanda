# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tasks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Task < ApplicationRecord
  belongs_to :user
  after_create :send_task_created_email

  private

  def send_task_created_email
    TaskMailer.task_created(self).deliver_now
  end
end
