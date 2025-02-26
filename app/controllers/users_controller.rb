class UsersController < ApplicationController
  include ActiveModel::Attributes
  #trying to figure out how to display the display name of a user that is responsible for a collection entry - had tried to use this to abstract away some code in the CE partial view - 
  def show
    @ee_user = User.find_by(id: @collection_entry.user_id)
  end
end