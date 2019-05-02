class ChannelsController < ApplicationController
  before_action :set_channel, only: [:edit, :update, :destroy, :show]
  before_action :set_channels, only: [:index, :edit, :update, :destroy, :show]

  # GET /channels
  # GET /channels.json
  def index
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    @joined_channels = current_user.channels.order('name ASC')
    grouped_contents = @channel.feed_contents.order('created_at DESC')
    grouped_contents_included = grouped_contents.map(&:content)
    @grouped_contents = grouped_contents.group_by{|u| u.created_at.strftime('%Y/%m/%d')}
    @message = Message.new
  end
 
  # GET /channels/new
  def new
    @channel = Channel.new
  end

  def search_user
    @users = User.where('name LIKE(?)', "%#{params[:keyword]}%").where.not(id: current_user.id)
    respond_to do |format|
      format.json { render 'new', json: @users }
    end
  end

  def search
    @channels = Channel.where('name LIKE(?)', "%#{params[:keyword]}%")
    @current_user_channels_ids = current_user.channels.ids
    @joined_channels = Channel.where id: @channels.ids & @current_user_channels_ids
    @unjoined_channels = Channel.where id: @channels.ids - @current_user_channels_ids
    respond_to do |format|
      format.html
      format.json { render 'search', json: [@unjoined_channels, @joined_channels] }
    end
  end

  def participate
    @channel = Channel.find(participate_params[:channel_id])
    if (!@channel.users.exists?(current_user.id))
      @channel_user = ChannelUser.new(channel_id: @channel.id, user_id:current_user.id)
      respond_to do |format|
        if @channel_user.save
          format.html { redirect_to @channel, notice: 'Channel was successfully created.' }
          format.json { render :show, status: :created, location: @channel }
        else
          format.html { render :new }
          format.json { render json: @channel.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def unparticipate
    # binding.pry
    @channel = Channel.find(params[:id])
    @channel_user = ChannelUser.where(user_id: current_user.id, channel_id: @channel.id)
    ChannelUser.destroy(@channel_user.ids[0])
    respond_to do |format|
      format.html { redirect_to channels_path}
      format.json { head :no_content }
    end
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(name: channel_params[:name])
    user_ids = channel_params[:user_ids]
    user_ids << current_user.id

    respond_to do |format|
      if @channel.save
        user_ids.each do |user_id|
          ChannelUser.create(channel_id: @channel.id, user_id:user_id)
        end
        format.html { redirect_to @channel, notice: 'Channel was successfully created.' }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1
  # PATCH/PUT /channels/1.json
  def update
    isSaved = true
    user_ids = channel_params[:user_ids]

    user_ids.each do |user_id|
      if (!@channel.users.exists?(user_id))
        channel_user = ChannelUser.new(channel_id: @channel.id, user_id:user_id)
        if (!channel_user.save)
          isSaved = false
        end
      end
    end
    respond_to do |format|
      if isSaved
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channels_url, notice: 'Channel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def channel_params
      params.require(:channel).permit(:name, {user_ids:[]})
    end

    def participate_params
      params.permit(:channel_id)
    end

end
