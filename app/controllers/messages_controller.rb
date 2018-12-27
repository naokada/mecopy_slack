class MessagesController < ApplicationController

	def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
				format.json { render :show, status: :created, location: @message }
				redirect_to(controller: "channels", action: "index") and return
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
		end

		respond_to do |format|
			format.html #default rendering
		end
	end
	
	private
		def message_params
			params.require(:message).permit(:content)
		end

end
