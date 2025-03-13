class Chicken < ApplicationRecord
  has_many :egg_entries
  belongs_to :household

  validates :name, :breed, presence: true
  validates :dob, presence: { message: '(date of birth) can\'t be blank' }

  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }

  NULL_CHICKEN = new(id: nil, name: 'Flock Mode Placeholder', breed: 'ghost', tell: 'not really a chicken', dob: Time.now, status: 'layer')
  NULL_CHICKEN.freeze # does not save to Active Record
end
