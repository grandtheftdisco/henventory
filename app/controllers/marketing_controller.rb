class MarketingController < ApplicationController
  def home
    # remember to scope to current household once that PR is approved!
    @collection_entries = CollectionEntry.includes(egg_entries: :chicken)
    .where(created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day)
    .order("created_at desc")
  end

  def settings
    @user = Current.user
    @household = Current.household
  end
end