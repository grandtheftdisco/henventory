class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend

  allow_browser versions: :modern
  around_action :set_time_zone if Current.user

  # return the start and end limits of the collection as a 2 items array
  def pagy_calendar_period(collection)
    starting = collection.minimum(:created_at) || Time.current
    ending   = collection.maximum(:created_at) || Time.current
    [starting.in_time_zone, ending.in_time_zone]
  end

  # return the collection filtered by a time period
  def pagy_calendar_filter(collection, from, to)
    collection.where(created_at: from...to)
  end

  private

  def set_time_zone
    old_time_zone = Time.zone
    @local_time_zone = Current.user.household.time_zone
    Time.zone = @local_time_zone
    yield
  ensure
    Time.zone = old_time_zone
  end
end
