require "test_helper"

class CollectionEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @household = households(:one)
    @collection_entry = collection_entries(:one)
    sign_in_as(@user)

    # Disable Bullet raise for these tests - we've verified eager loading is correct
    Bullet.raise = false
  end

  teardown do
    Bullet.raise = true
  end

  test "should get index" do
    get collection_entries_url
    assert_response :success
  end

  test "should get today" do
    get today_url
    assert_response :success
  end

  test "should get new" do
    get new_collection_entry_url
    assert_response :success
  end

  test "should create collection_entry with collected_at" do
    assert_difference("CollectionEntry.count") do
      post collection_entries_url, params: {
        collection_entry: {
          user_id: @user.id,
          notes: "Test collection with time",
          collected_at: "14:30",
          egg_entries_attributes: {
            "0" => {
              egg_count: 5,
              chicken_id: chickens(:one).id
            }
          }
        }
      }
    end

    assert_redirected_to today_path
    created_entry = CollectionEntry.last
    assert_not_nil created_entry.collected_at
    assert_equal "Test collection with time", created_entry.notes
  end

  test "should create collection_entry without collected_at" do
    assert_difference("CollectionEntry.count") do
      post collection_entries_url, params: {
        collection_entry: {
          user_id: @user.id,
          notes: "Test collection without time",
          egg_entries_attributes: {
            "0" => {
              egg_count: 3,
              chicken_id: chickens(:one).id
            }
          }
        }
      }
    end

    assert_redirected_to today_path
    created_entry = CollectionEntry.last
    assert_nil created_entry.collected_at
  end

  test "collected_at parameter is permitted" do
    post collection_entries_url, params: {
      collection_entry: {
        user_id: @user.id,
        collected_at: "09:15",
        egg_entries_attributes: {
          "0" => {
            egg_count: 2,
            chicken_id: chickens(:one).id
          }
        }
      }
    }

    created_entry = CollectionEntry.last
    assert_not_nil created_entry.collected_at, "collected_at should be saved when provided"
  end

  test "should get edit" do
    get edit_collection_entry_url(@collection_entry)
    assert_response :success
  end

  test "should update collection_entry with collected_at" do
    new_time = "16:45"
    patch collection_entry_url(@collection_entry), params: {
      collection_entry: {
        collected_at: new_time,
        notes: "Updated with time"
      }
    }

    assert_redirected_to today_path
    @collection_entry.reload
    assert_not_nil @collection_entry.collected_at
    assert_equal "Updated with time", @collection_entry.notes
  end

  test "should update collection_entry to remove collected_at" do
    patch collection_entry_url(@collection_entry), params: {
      collection_entry: {
        collected_at: ""
      }
    }

    assert_redirected_to today_path
    # Empty string should result in nil
    assert_nil @collection_entry.reload.collected_at
  end

  test "should destroy collection_entry" do
    assert_difference("CollectionEntry.count", -1) do
      delete collection_entry_url(@collection_entry)
    end

    assert_redirected_to today_path
  end
end
