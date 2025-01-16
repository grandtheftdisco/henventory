require "application_system_test_case"

class ChickensTest < ApplicationSystemTestCase
  setup do
    @chicken = chickens(:one)
  end

  test "visiting the index" do
    visit chickens_url
    assert_selector "h1", text: "Chickens"
  end

  test "should create chicken" do
    visit chickens_url
    click_on "New chicken"

    fill_in "Breed", with: @chicken.breed
    fill_in "Name", with: @chicken.name
    fill_in "Tell", with: @chicken.tell
    click_on "Create Chicken"

    assert_text "Chicken was successfully created"
    click_on "Back"
  end

  test "should update Chicken" do
    visit chicken_url(@chicken)
    click_on "Edit this chicken", match: :first

    fill_in "Breed", with: @chicken.breed
    fill_in "Name", with: @chicken.name
    fill_in "Tell", with: @chicken.tell
    click_on "Update Chicken"

    assert_text "Chicken was successfully updated"
    click_on "Back"
  end

  test "should destroy Chicken" do
    visit chicken_url(@chicken)
    click_on "Destroy this chicken", match: :first

    assert_text "Chicken was successfully destroyed"
  end
end
