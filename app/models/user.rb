# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  balance                :decimal(10, 2)   default(0.0)
#  default_address        :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  wallet_data            :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :default_address, uniqueness: true, allow_nil: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :user_tandas
  has_many :tandas, through: :user_tandas, foreign_key: 'creator_id'
  has_many :transactions, through: :user_tandas

  has_many :sent_follow_requests, foreign_key: :sender_id, class_name: "FollowRequest", dependent: :destroy

  has_many :accepted_sent_follow_requests, -> { accepted }, foreign_key: :sender_id, class_name: "FollowRequest"

  has_many :received_follow_requests, foreign_key: :recipient_id, class_name: "FollowRequest"

  has_many :accepted_received_follow_requests, -> { accepted }, foreign_key: :recipient_id, class_name: "FollowRequest"

  has_many :followers, through: :accepted_received_follow_requests, source: :sender
  
  has_many :following, through: :accepted_sent_follow_requests, source: :recipient
end
