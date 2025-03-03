class UsersController < ApplicationController
  include ActiveModel::Attributes

  def show
  end

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id 
      render :new
    else
      redirect_to '/signup'
    end   
  end

  private
    def user_params
      params.require(:user).permit(:display_name, :email_address, :password, :password_confirmation)
    end
end