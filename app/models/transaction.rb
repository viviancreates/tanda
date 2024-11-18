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
 
end
