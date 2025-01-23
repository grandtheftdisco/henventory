require "test_helper"

class EggEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @egg_entry = egg_entries(:one)
  end

  test "should get index" do
    get egg_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_egg_entry_url
    assert_response :success
  end

  test "should create egg_entry" do
    assert_difference("EggEntry.count") do
      post egg_entries_url, params: { egg_entry: { chicken_id: @egg_entry.chicken_id, collection_entry_id: @egg_entry.collection_entry_id, egg_count: @egg_entry.egg_count } }
    end

    assert_redirected_to egg_entry_url(EggEntry.last)
  end

  test "should show egg_entry" do
    get egg_entry_url(@egg_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_egg_entry_url(@egg_entry)
    assert_response :success
  end

  test "should update egg_entry" do
    patch egg_entry_url(@egg_entry), params: { egg_entry: { chicken_id: @egg_entry.chicken_id, collection_entry_id: @egg_entry.collection_entry_id, egg_count: @egg_entry.egg_count } }
    assert_redirected_to egg_entry_url(@egg_entry)
  end

  test "should destroy egg_entry" do
    assert_difference("EggEntry.count", -1) do
      delete egg_entry_url(@egg_entry)
    end

    assert_redirected_to egg_entries_url
  end
end
