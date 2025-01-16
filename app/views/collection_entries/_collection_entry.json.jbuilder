json.extract! collection_entry, :id, :count, :user_id, :chicken_id, :created_at, :updated_at
json.url collection_entry_url(collection_entry, format: :json)
