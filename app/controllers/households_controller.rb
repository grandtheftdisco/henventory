class HouseholdsController < ApplicationController
  before_action :set_household

  def edit
  end

  private
    def set_household
        @household = Current.household
      end

    def household_params
      params.require(:household).permit(:name)
    end
end
