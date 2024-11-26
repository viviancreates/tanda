# == Schema Information
#
# Table name: invitations
#
#  id          :bigint           not null, primary key
#  status      :string           default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :integer          not null
#  sender_id   :integer          not null
#  tanda_id    :integer          not null
#
# Indexes
#
#  index_invitations_on_receiver_id  (receiver_id)
#  index_invitations_on_sender_id    (sender_id)
#  index_invitations_on_tanda_id     (tanda_id)
#
class Invitation < ApplicationRecord
end
