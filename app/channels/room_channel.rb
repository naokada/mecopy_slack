class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['channel_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create!(content: data['message'], channel_id: params['channel_id'], user_id: current_user.id)
  end
end
