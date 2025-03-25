class Household < ApplicationRecord
  has_secure_token :invite_token 
  has_many :users
  has_many :chickens
  has_many :collection_entries
  
  def to_param
    invite_token
  end
end