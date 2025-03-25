class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :household
  has_many :chickens
  has_many :collection_entries
  after_create :seed_account

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private
    def seed_account
      ce = CollectionEntry.create(
        user_id: id,
        household_id: household_id,
        created_at: Time.current,
        updated_at: Time.current
      )

      if mode == "layer"
        chk = Chicken.create(
          name: "Sample Chicken",
          breed: "Leghorn",
          dob: Time.current,
          status: "pullet",
          tell: "lives in the computer (unlike your actual chickens)",
          household_id: household_id,
          image_url: "https://static-00.iconduck.com/assets.00/hatching-chick-emoji-2048x1941-k2v2nyey.png",
        )
        ee = EggEntry.create(
          egg_count: 1,
          collection_entry_id: ce.id,
          chicken_id: chk.id
        )
      elsif mode == "flock"
        ee = EggEntry.create(
          egg_count: 1,
          collection_entry_id: ce.id,
          chicken_id: nil
        )
      end
    end
end
