class CollectionEntriesController < ApplicationController
  before_action :set_collection_entry, only: %i[ edit update destroy ]

  # GET /collection_entries or /collection_entries.json
  def index
    @collection_entries = Current.household.collection_entries.includes(egg_entries: :chicken).order("created_at desc")
  end

  def today
    @collection_entries = Current.household.collection_entries.includes(egg_entries: :chicken)
    .where(created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day)
    .order("created_at desc")
  end

  # GET /collection_entries/1 or /collection_entries/1.json
  def show
    @collection_entry = Current.household.collection_entries.includes(egg_entries: :chicken).find(params.expect(:id))
    
  end

  # GET /collection_entries/new
  def new
    @collection_entry = Current.household.collection_entries.build
    @collection_entry.egg_entries.build
    setup_form_data
  end

  # GET /collection_entries/1/edit
  def edit
    setup_form_data
    @collection_entry = Current.household.collection_entries.find(params[:id])
    @collection_entry.egg_entries = EggEntry.where(collection_entry_id: @collection_entry.id)
  end

  # POST /collection_entries or /collection_entries.json
  def create
    @collection_entry = Current.household.collection_entries.build(collection_entry_params)
    setup_form_data

    respond_to do |format|
      if @collection_entry.save
        format.html { redirect_to @collection_entry, notice: "Collection entry was successfully created." }
        format.json { render :show, status: :created, location: @collection_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collection_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collection_entries/1 or /collection_entries/1.json
  def update
    respond_to do |format|
      if @collection_entry.update(collection_entry_params)
        format.html { redirect_to @collection_entry, notice: "Collection entry was successfully updated." }
        format.json { render :show, status: :ok, location: @collection_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collection_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collection_entries/1 or /collection_entries/1.json
  def destroy
    @collection_entry.destroy!

    respond_to do |format|
      format.html { redirect_to collection_entries_path, status: :see_other, notice: "Collection entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection_entry
      @collection_entry = Current.household.collection_entries.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def collection_entry_params
      params.require(:collection_entry).permit(:user_id, egg_entries_attributes: [
        :id, :egg_count, :chicken_id, :collection_entry_id, :_destroy,
      ])
    end

    def setup_form_data
      @users = Current.household.users
      @chickens = Current.household.chickens
    end
end
