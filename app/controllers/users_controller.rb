class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def show
    @user = Current.user
    @household = Current.household
    @expired_chickens = Current.household
      .chickens
      .where(status: :expired)
  end

  def new
    @user = User.build
    @household = Household.find_by(invite_token: params[:household_invite_token]) if params[:household_invite_token] #kv pair arg to find_by
  end

  def edit
    @user = Current.user
  end

  def create
    user = User.new(user_params)
    if params[:household].key?(:invite_token)
      user.household = Household.find_by(invite_token: params[:household][:invite_token])
    else 
      user.build_household(time_zone: params[:household][:time_zone])
    end
    
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
      redirect_to settings_path, 
        notice: "User settings were successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user)
        .permit(
          :display_name, :email_address, :password, :household_id, 
          :password_confirmation, :mode
        )
    end
end