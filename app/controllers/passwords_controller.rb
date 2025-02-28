class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def show
  end

  # renders password recovery form
  def new
  end

  # sends password reset email using PasswordsMailer.rest
  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  # renders password edit form if the correct token is present in the URL
  # if token is not present or invalid, user gets redirected to #new
  def edit
  end

  # updates password, as long as password & password confirmation match
  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
