# == Schema Information
#
# Table name: tandas
#
#  id             :bigint           not null, primary key
#  creator_wallet :string
#  due_date       :datetime
#  goal_amount    :integer
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :integer
#
class Tanda < ApplicationRecord
  has_many :user_tandas
  has_many :transactions
  has_many :users, through: :user_tandas
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  

  def creator_wallet_address
    creator_wallet || "No wallet linked"
  end
end
