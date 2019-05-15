class DirectsController < ApplicationController
  before_action :set_channels, only: [:show]
  def show
    @direct = Direct.find(params[:id])
    @grouped_messages = DirectMessage.grouped_in_direct(params[:id])
    @message = DirectMessage.new
  end

  def new
    @direct = Direct.new
    @users = User.where.not(id: current_user.id)
  end

  def create
    # TODO 誰も選択していない時の処理
    user_ids = direct_params[:user_ids].map(&:to_i)
    id = Direct.get_duplicated_dm_id(current_user, user_ids)
    if id == -1
      @direct = Direct.create
      DirectUser.transaction do
        user_ids.each do |user_id|
          DirectUser.create!(direct_id: @direct.id, user_id:user_id)
        end
      end
      respond_to do |format|
        format.html { redirect_to @direct, notice: 'DM room was successfully created.' }
        format.json { render :show, status: :created, location: @direct }
      end
    else
      redirect_to Direct.find(id)
    end
  end

  def direct_params
    params.require(:direct).permit({user_ids:[]})
  end
end
