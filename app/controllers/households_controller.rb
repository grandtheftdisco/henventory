class HouseholdsController < ApplicationController
  before_action :set_household

  # GET /households/1/edit
  def edit
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
