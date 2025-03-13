class ChickensController < ApplicationController
  before_action :set_chicken, only: %i[ show edit update destroy ]

  # GET /chickens or /chickens.json
  def index
    # excluding chicken 99 which is a placeholder for all flock-mode egg entries
    @chickens = Current.household.chickens.where(status: :layer).where.not(id: 99)
  end

  def pullets
    @chickens = Current.household.chickens.where(status: :pullet)
  end

  def expired
    @chickens = Current.household.chickens.where(status: :expired)
  end

  # GET /chickens/1 or /chickens/1.json
  def show
  end

  # GET /chickens/new
  def new
    @chicken = Current.household.chickens.build
  end

  # GET /chickens/1/edit
  def edit
  end

  # POST /chickens or /chickens.json
  def create
    @chicken = Current.household.chickens.build(chicken_params)

    respond_to do |format|
      if @chicken.save
        format.html { redirect_to @chicken, notice: "Chicken was successfully created." }
        format.json { render :show, status: :created, location: @chicken }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chicken.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chickens/1 or /chickens/1.json
  def update
    respond_to do |format|
      if @chicken.update(chicken_params)
        format.html { redirect_to @chicken, notice: "Chicken was successfully updated." }
        format.json { render :show, status: :ok, location: @chicken }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chicken.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chickens/1 or /chickens/1.json
  def destroy
    @chicken.destroy!

    respond_to do |format|
      format.html { redirect_to chickens_path, status: :see_other, notice: "Chicken was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chicken
      @chicken = Current.household.chickens.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def chicken_params
      # params.expect(chicken: [ :name, :breed, :tell ])
      params.require(:chicken).permit(:name, :breed, :tell, :dob, :image_url, :user_id, egg_entries_attributes: [
        :egg_count, :chicken_id, :collection_entry_id,
      ])
    end
end
