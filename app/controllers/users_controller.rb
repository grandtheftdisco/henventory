class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  include ActiveModel::Attributes

  def new
  end

  def edit
    @user = Current.user
  end

  def settings
    @user = Current.user
    @household = Current.household
    @expired_chickens = Current.household.chickens.where(status: :expired)
  end

  def create
    user = User.new(user_params)
    user.build_household
    if user.save
      start_new_session_for user 
      redirect_to '/'
    else
      raise user.errors.inspect
      render :new
    end   
  end

  def update
    @user = Current.user
    if @user.update(user_params)
      redirect_to settings_path, notice: "User settings were successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:display_name, :email_address, :password, :password_confirmation, :mode)
    end
end