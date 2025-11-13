require "application_system_test_case"

class CollectionEntriesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @household = households(:one)
    @collection_entry = collection_entries(:one)

    # Simulate logged in user
    Current.user = @user
    Current.household = @household
  end

  test "visiting the index" do
    visit collection_entries_url
    assert_selector "h1", text: "📒 All Entries"
  end

  test "visiting today's entries" do
    visit today_url
    assert_selector "h1", text: "📅 Today's Collections"
  end

  test "new form has timepicker field with flatpickr" do
    visit new_collection_entry_url

    # Check timepicker input exists with correct data attributes
    assert_selector "input[data-controller='flatpickr']"
    assert_selector "input[data-flatpickr-enable-time='true']"
    assert_selector "input[data-flatpickr-no-calendar='true']"
    assert_selector "input[data-flatpickr-date-format='h:i K']"
  end

  test "timepicker field is readonly to prevent manual typing" do
    visit new_collection_entry_url

    time_input = find("input[data-controller='flatpickr']")
    assert time_input[:readonly], "Timepicker should be readonly to force picker usage"
  end

  test "timepicker field has correct label" do
    visit new_collection_entry_url

    assert_text "What time did you collect these eggs?"
  end

  test "flatpickr calendar container exists in DOM after page load" do
    visit new_collection_entry_url

    # Give JavaScript time to initialize
    using_wait_time(2) do
      # Check that Flatpickr added its calendar container
      # The container may not be visible initially but should exist in DOM
      assert page.has_css?(".flatpickr-calendar", visible: :all),
             "Flatpickr calendar container should exist in DOM"
    end
  end

  test "flatpickr adds correct classes to input" do
    visit new_collection_entry_url

    # Flatpickr adds these classes when it initializes
    using_wait_time(2) do
      assert_selector "input.flatpickr-input[data-controller='flatpickr']"
    end
  end

  test "collected_at field name attribute is correct" do
    visit new_collection_entry_url

    assert_selector "input[name='collection_entry[collected_at]']"
  end

  # Note: Full form submission tests would require more complex setup
  # including user authentication and valid nested attributes for egg_entries
end
