# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :integer
#  date             :datetime
#  description      :string
#  transaction_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_tanda_id    :integer
#
class Transaction < ApplicationRecord
  belongs_to :user_tanda

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :description, presence: true
  validates :transaction_type, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "date", "description", "transaction_type"]
  end

  def trackable_type
    "Transaction"
  end

  def trackable_id
    id
  end
end
