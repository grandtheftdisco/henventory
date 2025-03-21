class EggEntriesController < ApplicationController
  before_action :set_egg_entry, only: %i[ show edit update destroy ]

  # GET /egg_entries/new
  def new
    @egg_entry = EggEntry.new(egg_entry_params)
    @chickens = Current.user.household.chickens
  end

  # GET /egg_entries/1/edit
  def edit
  end

  # POST /egg_entries or /egg_entries.json
  def create
    raise params.permit!.to_h.inspect
    @egg_entry = EggEntry.new(egg_entry_params)
    @chickens = Current.user.household.chickens

    if @egg_entry.save
      redirect_to @egg_entry, notice: "Egg entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /egg_entries/1 or /egg_entries/1.json
  def update
    if @egg_entry.update(egg_entry_params)
      redirect_to @egg_entry, notice: "Egg entry was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /egg_entries/1 or /egg_entries/1.json
  def destroy
    @egg_entry.destroy!

    redirect_to egg_entries_path, status: :see_other, notice: "Egg entry was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_egg_entry
      @egg_entry = EggEntry.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def egg_entry_params
      params.expect(egg_entry: [ :egg_count, :collection_entry_id ])
    end
end
