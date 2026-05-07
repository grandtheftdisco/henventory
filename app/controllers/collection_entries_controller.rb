class CollectionEntriesController < ApplicationController
  before_action :set_collection_entry, only: %i[ edit update destroy ]

  def index
    collection_entries = Current.household
      .collection_entries
      .includes(:user, egg_entries: :chicken)
      .order("created_at desc")

    @calendar, @pagy, @collection_entries = pagy_calendar(
      collection_entries,
      year: {},
      month: { format: '%B %Y' },
      week: { format: 'w of %b %d' },
      day:  { format: '%b %d' },
      pagy: {},
      active: params[:skip]
    )
    set_local_time_zone
  end

  def today
    set_local_time_zone
    @viewing_date = parse_viewing_date(params[:date]) || household_time.to_date
    @is_today = @viewing_date == household_time.to_date

    day_start = @viewing_date.in_time_zone(@local_time_zone).beginning_of_day
    day_end = day_start.end_of_day

    @collection_entries = Current.household.collection_entries.includes(:user, egg_entries: :chicken)
    .where(created_at: day_start..day_end)
    .order("created_at desc")

    @todays_egg_total = @collection_entries.sum { |entry| entry.egg_entries.sum(&:egg_count) }
  end

  def new
    @collection_entry = Current.household.collection_entries.build
    @collection_entry.egg_entries.build
    setup_form_data
  end

  def edit
    setup_form_data
    @collection_entry = Current.household.collection_entries.find(params[:id])
    @collection_entry.egg_entries = EggEntry.where(collection_entry_id: @collection_entry.id)
  end

  def create
    if Current.user.mode == "layer"
      @collection_entry = Current.household.collection_entries.build(collection_entry_params)

      if @collection_entry.save
        redirect_to today_path, notice: "Collection entry was successfully created."
      else
        setup_form_data
        render :new, status: :unprocessable_entity
      end
    else
      @collection_entry = Current.household.collection_entries.build(collection_entry_params)
      @users = Current.household.users.all

      if @collection_entry.save
        redirect_to today_path,
          notice: "Collection entry was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update 
    if @collection_entry.update(collection_entry_params)
      redirect_to today_path,
        notice: "Collection entry was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collection_entry.destroy!
 
    redirect_to today_path, status: :see_other, 
      notice: "Collection entry was successfully destroyed."
  end

  private
    def set_collection_entry
      @collection_entry = Current.household
        .collection_entries
        .find(params.expect(:id))
    end

    def collection_entry_params
      params.require(:collection_entry)
        .permit(:user_id,
                :notes,
                :collected_at,
                egg_entries_attributes: [
                  :id,
                  :egg_count,
                  :chicken_id,
                  :collection_entry_id,
                  :_destroy,
        ]
      )
    end

    def setup_form_data
      @users = Current.household.users
      @chickens = Current.household.chickens.where(status: :layer)
    end

    def set_local_time_zone
      @local_time_zone = Current.user.household.time_zone
    end

    # Parses a YYYY-MM-DD param into a Date. Returns nil for blank or
    # malformed input so the caller can fall back to "today" rather than
    # 500ing on a bad query string.
    def parse_viewing_date(raw)
      return nil if raw.blank?
      Date.iso8601(raw.to_s)
    rescue ArgumentError, TypeError
      nil
    end
end