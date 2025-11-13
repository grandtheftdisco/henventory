require "test_helper"

class CollectionEntryTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    collection_entry = collection_entries(:one)
    assert collection_entry.valid?
  end

  test "should allow collected_at to be nil" do
    collection_entry = collection_entries(:one)
    collection_entry.collected_at = nil
    assert collection_entry.valid?
  end

  test "should allow collected_at to be set" do
    collection_entry = collection_entries(:one)
    time = Time.zone.parse("2025-11-13 08:30:00")
    collection_entry.collected_at = time
    assert collection_entry.save
    assert_equal time, collection_entry.reload.collected_at
  end

  test "should accept time string in H:i format" do
    collection_entry = collection_entries(:one)
    # When submitted from the form, it will be a string
    collection_entry.collected_at = "14:30"
    assert collection_entry.save
    assert_not_nil collection_entry.collected_at
  end

  test "should have associations" do
    collection_entry = collection_entries(:one)
    assert_respond_to collection_entry, :egg_entries
    assert_respond_to collection_entry, :user
    assert_respond_to collection_entry, :household
  end

  test "should destroy dependent egg_entries" do
    collection_entry = collection_entries(:one)
    assert_difference('EggEntry.count', -collection_entry.egg_entries.count) do
      collection_entry.destroy
    end
  end
end
