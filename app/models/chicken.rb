class Chicken < ApplicationRecord
  has_many :egg_entries
  belongs_to :household

  validates :name, :breed, presence: true
  validates :dob, presence: { message: '(date of birth) can\'t be blank' }

  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }
end
