class BackfillChickenAccentColors < ActiveRecord::Migration[8.0]
  # Backfills accent_color (and accent_secondary for patterned breeds) on
  # existing chickens by matching their `breed` string against the
  # Chicken::BREED_TINTS registry. Chickens whose breed doesn't match any
  # registry entry are left with NULL accents; they'll either get accents
  # picked up if the breed is later edited to a known value, or via the
  # Custom-breed picker on the redesigned New Chicken form.
  #
  # Safe to run inline: dataset is < 1000 rows. Wrapped in a transaction by
  # default (ActiveRecord::Migration). Idempotent: skips chickens that
  # already have an accent_color set.
  def up
    # Use a lightweight anonymous model to avoid coupling this migration to
    # whatever future shape Chicken takes. We only need read/write of
    # breed, accent_color, accent_secondary.
    chicken_model = Class.new(ActiveRecord::Base) do
      self.table_name = "chickens"
    end

    tints = Chicken::BREED_TINTS

    chicken_model.where(accent_color: nil).find_each do |row|
      next if row.breed.blank?

      match = tints.find { |b| b[:name].casecmp?(row.breed.to_s.strip) }
      next unless match

      row.update_columns(
        accent_color: match[:tint],
        accent_secondary: match[:secondary]
      )
    end
  end

  def down
    # Non-destructive backfill; nothing to roll back. Leaving as a no-op so
    # rolling back this migration doesn't wipe out any subsequent
    # user-edited accent values.
  end
end
