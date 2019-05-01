class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['channel_id']}_#{params['channel_type']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    message = Message.create!(content: data['message'], channel_id: params['channel_id'], user_id: current_user.id)
    # message.feed_content = FeedContent.create(channel_id: params['channel_id'], updated_at: message.updated_at)
  end
end
