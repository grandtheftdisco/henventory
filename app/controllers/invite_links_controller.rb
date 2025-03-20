class InviteLinksController < ApplicationController
  def show
    @household = Household.find_by_invite_token(params[:household_invite_token]) # or should this be invite_token?
    @household.regenerate_invite_token
    @invite_link = new_household_user_url(@household)
    respond_to do |format|
      format.html
    end
  end
end