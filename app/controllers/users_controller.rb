class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  include ActiveModel::Attributes

  def show
  end

  def new
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

  private
    def user_params
      params.require(:user).permit(:display_name, :email_address, :password, :password_confirmation)
    end
end