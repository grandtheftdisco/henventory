class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend

  allow_browser versions: :modern

  # return the start and end limits of the collection as a 2 items array
  def pagy_calendar_period(collection)
    starting = collection.minimum(:created_at) || Time.current
    ending   = collection.maximum(:created_at) || Time.current
    [starting.in_time_zone(@local_time_zone), ending.in_time_zone(@local_time_zone)]
  end

  # return the collection filtered by a time period
  def pagy_calendar_filter(collection, from, to)
    collection.where(created_at: from...to)
  end

  private

  def household_time
    Time.current
        .in_time_zone(Current.household.time_zone)
  end

  def set_local_time_zone
    @local_time_zone = Current.user
                              .household
                              .time_zone
  end
end
