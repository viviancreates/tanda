# == Schema Information
#
# Table name: tandas
#
#  id          :bigint           not null, primary key
#  due_date    :datetime
#  goal_amount :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :integer
#
class Tanda < ApplicationRecord
end
