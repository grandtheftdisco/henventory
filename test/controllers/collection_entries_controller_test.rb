require "test_helper"

class CollectionEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection_entry = collection_entries(:one)
  end

  test "should get index" do
    get collection_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_collection_entry_url
    assert_response :success
  end

  test "should create collection_entry" do
    assert_difference("CollectionEntry.count") do
      post collection_entries_url, params: { collection_entry: { chicken_id: @collection_entry.chicken_id, count: @collection_entry.count, user_id: @collection_entry.user_id } }
    end

    assert_redirected_to collection_entry_url(CollectionEntry.last)
  end

  test "should show collection_entry" do
    get collection_entry_url(@collection_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_collection_entry_url(@collection_entry)
    assert_response :success
  end

  test "should update collection_entry" do
    patch collection_entry_url(@collection_entry), params: { collection_entry: { chicken_id: @collection_entry.chicken_id, count: @collection_entry.count, user_id: @collection_entry.user_id } }
    assert_redirected_to collection_entry_url(@collection_entry)
  end

  test "should destroy collection_entry" do
    assert_difference("CollectionEntry.count", -1) do
      delete collection_entry_url(@collection_entry)
    end

    assert_redirected_to collection_entries_url
  end
end
