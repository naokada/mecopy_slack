class ChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_channel, only: [:show, :edit, :update, :destroy]

  # GET /channels
  # GET /channels.json
  def index
    @channels = Channel.all
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    @channels = Channel.all
    @channel = Channel.find(params[:id])
    # @grouped_messages = @channel.messages.includes(:user).order('created_at DESC').group_by{|u| u.created_at.strftime('%Y/%m/%d')}
    grouped_contents = @channel.feed_contents.order('created_at DESC')
    grouped_contents_included = grouped_contents.map(&:content)
    @grouped_contents = grouped_contents.group_by{|u| u.created_at.strftime('%Y/%m/%d')}
    @message = Message.new
    # binding.pry
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  def search
    @users = User.where('name LIKE(?)', "%#{params[:keyword]}%")
    respond_to do |format|
      format.json { render 'new', json: @users }
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
    respond_to do |format|
      if @channel.update(channel_params)
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
