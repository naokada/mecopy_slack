class ChannelUser < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  #validation
  validates_presence_of :user_id, :channel_id

  after_save :channel_participate_message_generater
  after_destroy :channel_unparticipate_message_generater

  scope :where_user_channel, ->(user_id, channel_id) { where(user_id: user_id, channel_id: channel_id) }

  def channel_participate_message_generater
    Message.create(content: "PARTICIPATE", content_type: "participate", user_id: user_id, channel_id: channel_id)
  end
  def channel_unparticipate_message_generater
    Message.create(content: "UNPARTICIPATE", content_type: "unparticipate", user_id: user_id, channel_id: channel_id)
  end
end
