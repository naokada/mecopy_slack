class DirectMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(direct_message)
    ActionCable.server.broadcast "direct_channel_#{direct_message.direct_id}", direct_message: render_direct_message(direct_message)
  end

  private
    def render_direct_message(direct_message)
      ApplicationController.renderer.render(partial: 'directs/message', locals: {message: direct_message})
    end
end

