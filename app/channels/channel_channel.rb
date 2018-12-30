class ChannelChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['channel_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    binding.pry
    Message.create!(content: data['message'], channel_id: params['channel_id'])
  end
end
