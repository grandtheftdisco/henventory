class Session < ApplicationRecord
  belongs_to :user
  
  def household
    user&.household
  end
end