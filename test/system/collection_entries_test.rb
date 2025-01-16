require "application_system_test_case"

class CollectionEntriesTest < ApplicationSystemTestCase
  setup do
    @collection_entry = collection_entries(:one)
  end

  test "visiting the index" do
    visit collection_entries_url
    assert_selector "h1", text: "Collection entries"
  end

  test "should create collection entry" do
    visit collection_entries_url
    click_on "New collection entry"

    fill_in "Chicken", with: @collection_entry.chicken_id
    fill_in "Count", with: @collection_entry.count
    fill_in "User", with: @collection_entry.user_id
    click_on "Create Collection entry"

    assert_text "Collection entry was successfully created"
    click_on "Back"
  end

  test "should update Collection entry" do
    visit collection_entry_url(@collection_entry)
    click_on "Edit this collection entry", match: :first

    fill_in "Chicken", with: @collection_entry.chicken_id
    fill_in "Count", with: @collection_entry.count
    fill_in "User", with: @collection_entry.user_id
    click_on "Update Collection entry"

    assert_text "Collection entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Collection entry" do
    visit collection_entry_url(@collection_entry)
    click_on "Destroy this collection entry", match: :first

    assert_text "Collection entry was successfully destroyed"
  end
end
