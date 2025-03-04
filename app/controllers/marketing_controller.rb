class MarketingController < ApplicationController
  def home
    # remember to scope to current household once that PR is approved!
    @collection_entries = Current.household.collection_entries.includes(egg_entries: :chicken)
    .where(created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day)
    .order("id DESC")
  end
end