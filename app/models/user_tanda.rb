# == Schema Information
#
# Table name: user_tandas
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tanda_id   :integer
#  user_id    :integer
#
class UserTanda < ApplicationRecord
  belongs_to :user
  belongs_to :tanda
  has_many :transactions

  def tanda_name
    tanda.name
  end

  def trackable_type
    "UserTanda"
  end

  def trackable_id
    id
  end
end
