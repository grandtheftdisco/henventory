class BackfillProductionBlueAccents < ActiveRecord::Migration[8.0]
  # Adds the Production Blue tint retroactively. The original
  # BackfillChickenAccentColors migration ran before Production Blue was
  # in the BREED_TINTS registry, so any Production Blues created before
  # this migration ran are sitting with NULL accents.
  #
  # Idempotent: only touches rows where accent_color is nil and breed
  # matches "Production Blue" case-insensitively. Won't disturb
  # user-edited accents (e.g., custom-color picker selections in Phase 2+).
  #
  # Safe to run inline at any household scale we expect (< 1000 rows).
  def up
    chicken_model = Class.new(ActiveRecord::Base) do
      self.table_name = "chickens"
    end

    match = Chicken::BREED_TINTS.find { |b| b[:name].casecmp?("Production Blue") }
    return unless match # safety: silently no-op if the tint was renamed/removed

    chicken_model.where(accent_color: nil)
      .where("LOWER(TRIM(breed)) = ?", "production blue")
      .update_all(accent_color: match[:tint])
  end

  def down
    # Non-destructive backfill; nothing to roll back. Leaving as a no-op so
    # rolling back this migration doesn't wipe out user-edited accents.
  end
end
