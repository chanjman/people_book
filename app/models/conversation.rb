# == Schema Information
#
# Table name: conversations
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Conversation < ApplicationRecord
  # Associations
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, -> { order(created_at: :asc) },
           dependent: :destroy

  # Validations
  validates :sender, uniqueness: { scope: :receiver }

  # Scopes
  scope :with_user, ->(user) { unscope(:where).where('? IN (sender_id, receiver_id)', user.id) }
  scope :between, ->(user1, user2) { where('sender_id IN (:ids) AND receiver_id IN (:ids)', ids: [user1.id, user2.id]) }

  def other_user(current_user)
    sender == current_user ? receiver : sender
  end

  def participates?(user)
    sender == user || receiver == user
  end
end