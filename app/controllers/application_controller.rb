class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # return the start and end limits of the collection as a 2 items array
  def pagy_calendar_period(collection)
    starting = collection.minimum(:created_at)
    ending   = collection.maximum(:created_at)
    [starting.in_time_zone, ending.in_time_zone]
  end

  # return the collection filtered by a time period
  def pagy_calendar_filter(collection, from, to)
    collection.where(created_at: from...to)
  end

end
