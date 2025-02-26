class Session < ApplicationRecord
  belongs_to :user
  
  def household
    return if !user
    user.household
  end

end
