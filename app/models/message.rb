class Message < ApplicationRecord
	belongs_to :channel
	belongs_to :user
	validates :content, presence: true
	after_create_commit {MessageBroadcastJob.perform_later self}
	has_one :feed_content, as: :content, dependent: :destroy
end
