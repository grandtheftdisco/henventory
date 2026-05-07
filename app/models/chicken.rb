class Chicken < ApplicationRecord
  has_many :egg_entries, dependent: :destroy
  belongs_to :household

  enum :status, {
    pullet: "pullet",
    layer: "layer",
    molting: "molting",
    retired: "retired",
    expired: "expired"
  }, validate: { allow_nil: true }

  # Per-breed accent palette. The first match (case-insensitive) on `breed`
  # stamps `accent_color` (and `accent_secondary` for patterned breeds) onto
  # the chicken at save time. Used across the app for avatars, leaderboard
  # rows, calendar chips, and inline name links.
  BREED_TINTS = [
    { name: "Rhode Island Red",     tint: "#a8462a" },
    { name: "Rhode Island White",   tint: "#f4ede0" },
    { name: "ISA Brown",            tint: "#c2784a" },
    { name: "Cinnamon Queen",       tint: "#b66536" },
    { name: "Buff Orpington",       tint: "#d4a558" },
    { name: "Black Orpington",      tint: "#2a2520" },
    { name: "Lavender Orpington",   tint: "#bdb6c4" },
    { name: "Barred Rock",          tint: "#5a5550", secondary: "#e6e2d8" },
    { name: "Plymouth Rock",        tint: "#5a5550", secondary: "#e6e2d8" },
    { name: "Black Australorp",     tint: "#1f1c18" },
    { name: "Black Copper Maran",   tint: "#3a2a20" },
    { name: "Cuckoo Maran",         tint: "#6b6660", secondary: "#d8d4ca" },
    { name: "Wyandotte (Silver Laced)", tint: "#e8e3d6", secondary: "#2a2520" },
    { name: "Wyandotte (Gold Laced)",   tint: "#b88542", secondary: "#2a2520" },
    { name: "Speckled Sussex",      tint: "#7a4a2c", secondary: "#f0e8d8" },
    { name: "Light Sussex",         tint: "#f4ede0", secondary: "#2a2520" },
    { name: "Leghorn (White)",      tint: "#fbf6ec" },
    { name: "Leghorn (Brown)",      tint: "#a8783a" },
    { name: "Ameraucana",           tint: "#7a8a78" },
    { name: "Easter Egger",         tint: "#9a8870" },
    { name: "Olive Egger",          tint: "#6f7a4a" },
    { name: "Welsummer",            tint: "#8a4f2a" },
    { name: "New Hampshire Red",    tint: "#b25530" },
    { name: "Silkie (White)",       tint: "#fbf6ec" },
    { name: "Silkie (Black)",       tint: "#1f1c18" },
    { name: "Silkie (Buff)",        tint: "#d4a558" },
    { name: "Brahma (Light)",       tint: "#f4ede0", secondary: "#2a2520" },
    { name: "Brahma (Dark)",        tint: "#5a5048", secondary: "#e6e2d8" },
    { name: "Brahma (Buff)",        tint: "#d4a558" },
    { name: "Faverolles (Salmon)",  tint: "#e8c4a0" },
    { name: "Polish (White Crested Black)", tint: "#1f1c18", secondary: "#fbf6ec" },
    { name: "Dominique",            tint: "#6b6660", secondary: "#d8d4ca" },
    { name: "Delaware",             tint: "#f4ede0", secondary: "#2a2520" },
    { name: "Jersey Giant (Black)", tint: "#1a1814" },
    { name: "Buckeye",              tint: "#9a4528" },
    { name: "Chantecler",           tint: "#fbf6ec" }
  ].freeze

  # Curated palette offered when a user selects "Custom breed" in the New
  # Chicken form. The thirteenth swatch in that picker is a free-pick
  # rainbow (rendered in the view), so this list is intentionally 12 wide.
  CUSTOM_PALETTE = %w[
    #a8462a #d4a558 #8a4f2a #3a2a20 #1f1c18
    #fbf6ec #bfb098 #7a8a78 #6f7a4a #bdb6c4
    #c2784a #e8c4a0
  ].freeze

  before_validation :backfill_accent_from_breed

  validates :name, :breed, presence: true
  validates :dob, presence: { message: '(date of birth) can\'t be blank' }

  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }

  NULL_CHICKEN = new(
    id: nil,
    name: '[flock mode]',
    breed: 'ghost',
    tell: 'not really a chicken',
    dob: Time.now,
    status: 'layer',
    image_url: 'https://tinyurl.com/pt9b974e',
  ).tap { |record| record.readonly! }

  private

  def backfill_accent_from_breed
    return if accent_color.present?
    return if breed.blank?

    match = BREED_TINTS.find { |b| b[:name].casecmp?(breed.to_s.strip) }
    return unless match

    self.accent_color = match[:tint]
    self.accent_secondary = match[:secondary] if match[:secondary]
  end
end
