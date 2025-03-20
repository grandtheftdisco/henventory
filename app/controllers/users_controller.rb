class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  include ActiveModel::Attributes

  def show
  end

  def new
    @user = User.build
    @household = Household.find_by_invite_token(params[:invite_token]) if params[:invite_token]
    # will this pass the inviting household's id to the user?
    inviting_household_id = @household.id
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
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to settings_path, notice: "User settings were successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:display_name, :email_address, :password, :password_confirmation, :mode)
    end
end