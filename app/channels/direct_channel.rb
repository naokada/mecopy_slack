class DirectChannel < ApplicationCable::Channel
  def subscribed
    stream_from "direct_channel_#{params['direct_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    direct_message = DirectMessage.create(content: data['direct_message'], direct_id: params['direct_id'], user_id: current_user.id)
  end
end
