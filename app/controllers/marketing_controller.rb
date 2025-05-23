class MarketingController < ApplicationController
  allow_unauthenticated_access only: [ :hello, :faq, :how_it_works, :acknowledgements ]
  def home
    @collection_entries = Current.household
      .collection_entries
      .includes(egg_entries: :chicken)
      .where(
        created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day
      )
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