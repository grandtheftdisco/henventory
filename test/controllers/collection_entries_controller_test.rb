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
    assert_match(/Today/, @response.body)
  end

  test "should get today with explicit date param" do
    target = Date.current - 3.days
    get today_url(date: target.iso8601)
    assert_response :success
    # When viewing a non-today date, the heading reflects the chosen day.
    assert_match(target.strftime("%b"), @response.body)
    assert_no_match(/Today's Count/, @response.body)
  end

  test "should fall back to today when date param is malformed" do
    get today_url(date: "not-a-date")
    assert_response :success
    assert_match(/Today/, @response.body)
  end

  test "should fall back to today when date param is blank" do
    get today_url(date: "")
    assert_response :success
    assert_match(/Today/, @response.body)
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

  # ---- Turbo Stream submissions from Quick-Log ----

  test "Quick-Log submit responds with a stream replacing both quick_log frames" do
    @user.update!(mode: "layer")

    assert_difference("CollectionEntry.count") do
      post collection_entries_url,
        params: {
          quick_log: "1",
          collection_entry: {
            user_id: @user.id,
            egg_entries_attributes: {
              "0" => { egg_count: 1, chicken_id: chickens(:one).id }
            }
          }
        },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end

    assert_response :success
    assert_match %r{turbo-stream}, @response.media_type
    assert_match %r{turbo-stream action="replace" target="quick_log_inline"}, @response.body
    assert_match %r{turbo-stream action="replace" target="quick_log_sheet"}, @response.body
    assert_match %r{turbo-stream action="replace" target="dashboard_stats"}, @response.body
  end

  test "Quick-Log submit with invalid payload returns 422 stream and does not create" do
    @user.update!(mode: "layer")
    chicken = chickens(:one)
    # Two prior entries today already — third should be rejected by the
    # only_2_eggs_max_per_day_per_chicken validation.
    2.times do
      ce = @household.collection_entries.create!(user: @user, created_at: Time.current)
      ce.egg_entries.create!(chicken: chicken, egg_count: 1)
    end

    assert_no_difference("CollectionEntry.count") do
      post collection_entries_url,
        params: {
          quick_log: "1",
          collection_entry: {
            user_id: @user.id,
            egg_entries_attributes: {
              "0" => { egg_count: 1, chicken_id: chicken.id }
            }
          }
        },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end

    assert_response :unprocessable_entity
    assert_match %r{turbo-stream action="replace" target="quick_log_inline"}, @response.body
    # The error must surface in the DOM via an inline banner, not as a
    # blocking window.alert() injected from a <script> tag.
    assert_match %r{class="quick-log-flash"}, @response.body
    assert_no_match %r{window\.alert}, @response.body
    assert_no_match %r{<script}, @response.body
  end

  test "legacy form submit still gets HTML redirect, not turbo stream" do
    # Regression guard: the legacy /collection_entries/new form must NOT
    # receive a turbo-stream response, because the dashboard frames it
    # targets don't exist on that page. Without the quick_log marker it
    # should fall through to the redirect-to-today HTML path.
    @user.update!(mode: "layer")

    post collection_entries_url,
      params: {
        collection_entry: {
          user_id: @user.id,
          collected_at: "10:00",
          egg_entries_attributes: {
            "0" => { egg_count: 1, chicken_id: chickens(:one).id }
          }
        }
      },
      headers: { "Accept" => "text/vnd.turbo-stream.html, text/html, application/xhtml+xml" }

    assert_redirected_to today_path
  end
end
