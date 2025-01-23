require "application_system_test_case"

class EggEntriesTest < ApplicationSystemTestCase
  setup do
    @egg_entry = egg_entries(:one)
  end

  test "visiting the index" do
    visit egg_entries_url
    assert_selector "h1", text: "Egg entries"
  end

  test "should create egg entry" do
    visit egg_entries_url
    click_on "New egg entry"

    fill_in "Chicken", with: @egg_entry.chicken_id
    fill_in "Collection entry", with: @egg_entry.collection_entry_id
    fill_in "Egg count", with: @egg_entry.egg_count
    click_on "Create Egg entry"

    assert_text "Egg entry was successfully created"
    click_on "Back"
  end

  test "should update Egg entry" do
    visit egg_entry_url(@egg_entry)
    click_on "Edit this egg entry", match: :first

    fill_in "Chicken", with: @egg_entry.chicken_id
    fill_in "Collection entry", with: @egg_entry.collection_entry_id
    fill_in "Egg count", with: @egg_entry.egg_count
    click_on "Update Egg entry"

    assert_text "Egg entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Egg entry" do
    visit egg_entry_url(@egg_entry)
    click_on "Destroy this egg entry", match: :first

    assert_text "Egg entry was successfully destroyed"
  end
end
