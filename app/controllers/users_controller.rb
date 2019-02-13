class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    current_user.update(update_params)
    redirect_to root_path
  end

  private
  def update_params
    params.require(:user).permit(:name, :nickname, :role, :phone, :skype)
  end
end
