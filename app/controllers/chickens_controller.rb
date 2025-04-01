class ChickensController < ApplicationController
  before_action :set_chicken, only: %i[ show edit update destroy ]

  def index
    @chickens = Current.household.chickens.where.not(status: :expired)

    # filtering of view based on chicken status
    if params[:pullets]
      @chickens = @chickens.where(status: :pullet)
    elsif params[:expired]
      @chickens = @chickens.rewhere(status: :expired)
    elsif params[:layers]
      @chickens = @chickens.where(status: :layer)
    end
  end

  def show
    if @chicken.egg_entries.exists?
      @days_since_first_egg = (Time.now - @chicken.egg_entries.first.created_at) / (60*60*24)
      @weeks_since_first_egg = @days_since_first_egg / 7
      @days_since_last_egg = ((Time.now - @chicken.egg_entries.last.created_at) / (60*60*24)).truncate
      @eggs_laid_this_month = @chicken.egg_entries.where(created_at: Time.current.localtime.beginning_of_month..Time.current.localtime).sum(:egg_count)
    end
  end

  def new
    @chicken = Current.household.chickens.build
  end

  def edit
  end

  def create
    @chicken = Current.household.chickens.build(chicken_params)

    if @chicken.save
      redirect_to @chicken, notice: "Chicken was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @chicken.update(chicken_params)
      redirect_to @chicken, notice: "Chicken was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chicken.destroy!

    redirect_to chickens_path, status: :see_other, 
      notice: "Chicken was successfully destroyed."
  end

  private
    def set_chicken
      @chicken = Current.household.chickens.find(params.expect(:id))
    end

    def chicken_params
      params.require(:chicken)
        .permit(
          :name, :breed, :tell, :dob, :image_url, :user_id, :household_id, 
          :status, egg_entries_attributes: [
            :egg_count, :chicken_id, :collection_entry_id,
          ]
        )
    end
end