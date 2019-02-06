class DirectsController < ApplicationController
  # GET /channels/1
  # GET /channels/1.json
  def show
    @channels = Channel.all
    @joined_channels = current_user.channels
    @unjoined_channels = Channel.where id: @channels.ids - @joined_channels.ids
    @direct = Direct.find(params[:id])
    @grouped_messages = Message.where(channel_id: @direct.id, message_for: "direct").includes(:user).order('created_at DESC').group_by{|u| u.created_at.strftime('%Y/%m/%d')}
    # grouped_contents = @channel.messages.order('created_at DESC')
    # grouped_contents_included = grouped_contents.map(&:content)
    # @grouped_contents = grouped_contents.group_by{|u| u.created_at.strftime('%Y/%m/%d')}
    @message = Message.new
    # binding.pry
  end

  def new
    @direct = Direct.new
    @users = User.where.not(id: current_user.id)
  end

  def create
    # TODO 誰も選択していない時の処理

    @direct = Direct.new
    user_ids = direct_params[:user_ids].map(&:to_i)
    user_ids << current_user.id
    user_ids = user_ids.sort
    user_directs = current_user.directs

    existed_direct_users = []
    user_directs.each do |user_direct|
      existed_direct_user = {}
      existed_direct_user[:id] = user_direct.id
      existed_direct_user[:users] = user_direct.user_ids
      existed_direct_users << existed_direct_user
    end

    duplicated_dm = existed_direct_users.select {|edu| edu[:users] == user_ids}

    respond_to do |format|
      if duplicated_dm.length == 0
        if user_ids.count > 0 && @direct.save
          user_ids.each do |user_id|
            DirectUser.create(direct_id: @direct.id, user_id:user_id)
          end
          format.html { redirect_to @direct, notice: 'DM room was successfully created.' }
          format.json { render :show, status: :created, location: @direct }
        else
          format.html { render :new }
          format.json { render json: @direct.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to Direct.find(duplicated_dm[0][:id])}
      end
    end
  end

  def direct_params
    params.require(:direct).permit({user_ids:[]})
  end
end
