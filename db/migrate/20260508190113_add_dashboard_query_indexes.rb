class AddDashboardQueryIndexes < ActiveRecord::Migration[8.0]
  # Indexes backing the DashboardStats query patterns. Issue B from the
  # Phase 0 code review — without these, every dashboard read is a
  # sequential scan + nested-loop join.
  #
  # Composite (household_id, created_at) on collection_entries because
  # every dashboard query is scoped by household AND filtered by a
  # created_at range; the composite is strictly better than two singles
  # for that access pattern.
  #
  # Straight FK index on egg_entries.collection_entry_id because the
  # household has_many :egg_entries, through: :collection_entries join
  # loads egg_entries by `collection_entry_id IN (...)` and Rails doesn't
  # auto-index FKs on tables created before this migration.
  #
  # No index on egg_entries.created_at: with the Fix-A change to filter
  # by collection_entries.created_at instead, the egg's own timestamp
  # isn't queried in any hot path.
  def change
    add_index :collection_entries, [:household_id, :created_at]
    add_index :egg_entries, :collection_entry_id
  end
end
