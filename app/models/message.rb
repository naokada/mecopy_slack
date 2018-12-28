class Message < ApplicationRecord
	belongs_to :channel
	validates :content, presence: true
	after_create_commit {MessageBroadcastJob.perform_later self}
end
