class HouseholdsController < ApplicationController
  before_action :set_household, only: %i[ show edit update destroy ]

  # GET /households/new
  def new
    @household = Household.new
  end

  # GET /households/1/edit
  def edit
  end

  # POST /households or /households.json
  def create
    @household = Household.new(household_params)

    if @household.save
      redirect_to @household, notice: "Household was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /households/1 or /households/1.json
  def update
    if @household.update(household_params)
      redirect_to '/settings', notice: "Household was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /households/1 or /households/1.json
  def destroy
    @household.destroy!

    redirect_to households_path, status: :see_other, notice: "Household was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def household_params
      params.require(:household).permit(:name)
    end
end
