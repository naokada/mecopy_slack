class DirectMessage < ApplicationRecord
  belongs_to :direct
	belongs_to :user
  validates :content, presence: true
  after_create_commit {MessageBroadcastJob.perform_later self}
end
