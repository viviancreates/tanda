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
  has_many :user_tandas, dependent: :destroy
  has_many :transactions, through: :user_tandas, dependent: :destroy
  has_many :users, through: :user_tandas
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  def self.ransackable_attributes(auth_object = nil)
    ["due_date", "name"]
  end
  
  def to_s
    name
  end

  def creator_wallet_address
    creator_wallet || "No wallet linked"
  end
end
