class ChannelUser < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  has_one :feed_content, as: :content, dependent: :destroy
end
