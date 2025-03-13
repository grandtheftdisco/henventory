class MarketingController < ApplicationController
  allow_unauthenticated_access only: [ :home, :faq, :how_it_works, :acknowledgements ]
  def home
    if Current.user
      @collection_entries = Current.household.collection_entries.includes(egg_entries: :chicken)
      .where(created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day)
    end
  end

  def settings
    @user = Current.user
    @household = Current.household
  end

  def faq
  end

  def how_it_works
  end

  def acknowledgements
  end
end