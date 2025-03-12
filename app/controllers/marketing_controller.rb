class MarketingController < ApplicationController
  allow_unauthenticated_access only: [ :faq, :how_it_works ]
  def home
    @collection_entries = Current.household.collection_entries.includes(egg_entries: :chicken)
    .where(created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day)
    .order("created_at desc")
  end

  def settings
    @user = Current.user
    @household = Current.household
  end

  def faq
  end

  def how_it_works
  end
end