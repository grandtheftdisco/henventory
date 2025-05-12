class MarketingController < ApplicationController
  allow_unauthenticated_access only: [ :hello, :faq, :how_it_works, :acknowledgements ]
  def home
    set_local_time_zone
    @collection_entries = Current.household
      .collection_entries
      .includes(egg_entries: :chicken)
      .where(created_at: household_time.beginning_of_day..household_time.end_of_day)
  end

  def how_it_works
  end

  def acknowledgements
  end

  def faq
  end

  def hello
  end
end