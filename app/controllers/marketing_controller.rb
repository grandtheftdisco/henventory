class MarketingController < ApplicationController
  def home
    @collection_entries = Current.household.collection_entries.includes(egg_entries: :chicken)
    .where(created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day)
    .order("id desc")
  end
end