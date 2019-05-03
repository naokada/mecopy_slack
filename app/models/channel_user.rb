class ChannelUser < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  #validation
  validates_presence_of :user_id, :channel_id
end
