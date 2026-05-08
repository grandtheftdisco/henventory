class DashboardsController < ApplicationController
  def show
    if Current.user.mode == "layer"
      @stats = DashboardStats.new(Current.household)
      @now = household_time
      @quick_log = @stats.quick_log_eligibility
      @no_chickens = Current.household.chickens.none?
      render "dashboards/show"
    else
      @collection_entries = Current.household
        .collection_entries
        .includes(egg_entries: :chicken)
        .where(
          created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day
        )
      render "marketing/home"
    end
  end
end
