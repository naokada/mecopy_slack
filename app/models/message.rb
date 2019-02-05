class Message < ApplicationRecord
	enum message_for: [:channel, :directs]
	belongs_to :channel
	belongs_to :user
	validates :content, presence: true
	after_create_commit {MessageBroadcastJob.perform_later self}
	has_one :feed_content, as: :content, dependent: :destroy
	after_create :create_feed_content

	private
  def create_feed_content
    self.feed_content = FeedContent.create(channel_id: channel_id, updated_at: updated_at)
  end
end
