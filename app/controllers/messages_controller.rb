class MessagesController < ApplicationController

	def create

		@message = Message.new(message_params)
		@channel = Channel.find(params[:channel_id])

    respond_to do |format|
			if @message.save
        format.html { redirect_to @channel, notice: 'Message was successfully created.' }
				format.json { render :show, status: :created, location: @message }
      else
        format.html { redirect_to @channel, alert: 'Message was not created.' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
		end
	end

	private
		def message_params
			params.require(:message).permit(:content)
		end

end
