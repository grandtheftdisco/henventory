class MarketingController < ApplicationController
  allow_unauthenticated_access only: [ :hello, :faq, :how_it_works, :acknowledgements ]

  def how_it_works
  end

  def acknowledgements
  end

  def faq
  end

  def hello
  end
end