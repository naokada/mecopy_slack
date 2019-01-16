class ChannelUser < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  has_one :feed_content, as: :content, dependent: :destroy
 #callback
  after_create :create_feed_content

  #validation
  validates_presence_of :user_id, :channel_id

  private
  def create_feed_content
    self.feed_content = FeedContent.create(channel_id: question.channel_id, updated_at: updated_at)
  end
end
