require "application_system_test_case"

class HouseholdsTest < ApplicationSystemTestCase
  setup do
    @household = households(:one)
  end

  test "visiting the index" do
    visit households_url
    assert_selector "h1", text: "Households"
  end

  test "should create household" do
    visit households_url
    click_on "New household"

    click_on "Create Household"

    assert_text "Household was successfully created"
    click_on "Back"
  end

  test "should update Household" do
    visit household_url(@household)
    click_on "Edit this household", match: :first

    click_on "Update Household"

    assert_text "Household was successfully updated"
    click_on "Back"
  end

  test "should destroy Household" do
    visit household_url(@household)
    click_on "Destroy this household", match: :first

    assert_text "Household was successfully destroyed"
  end
end
