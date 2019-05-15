class DirectMessage < ApplicationRecord
  belongs_to :direct
  belongs_to :user
  validates :content, presence: true
  after_create_commit {DirectMessageBroadcastJob.perform_later self}

  scope :select_by_direct, ->(id) { where(direct_id: id) }
  scope :grouped, -> { order(created_at: :desc).group_by{|u| u.created_at.strftime('%Y/%m/%d')} }
  scope :grouped_in_direct, ->(id) { select_by_direct(id).grouped }
end
