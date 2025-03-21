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

    respond_to do |format|
      if @household.save
        format.html { redirect_to @household, notice: "Household was successfully created." }
        format.json { render :show, status: :created, location: @household }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /households/1 or /households/1.json
  def update
    respond_to do |format|
      if @household.update(household_params)
        format.html { redirect_to '/settings', notice: "Household was successfully updated." }
        format.json { render :show, status: :ok, location: @household }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /households/1 or /households/1.json
  def destroy
    @household.destroy!

    respond_to do |format|
      format.html { redirect_to households_path, status: :see_other, notice: "Household was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Current.household
    end

    # Only allow a list of trusted parameters through.
    def household_params
      params.require(:household).permit(:name)
    end
end
