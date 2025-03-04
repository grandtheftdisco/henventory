class CollectionEntriesController < ApplicationController
  before_action :set_collection_entry, only: %i[ edit update destroy ]

  # GET /collection_entries or /collection_entries.json
  def index
    # remember to scope to current household once that PR is approved!
    @collection_entries = CollectionEntry.includes(egg_entries: :chicken).order("id :desc")
  end

  def today
    # remember to scope to current household once that PR is approved!
    @collection_entries = CollectionEntry.includes(egg_entries: :chicken)
    .where(created_at: Time.current.localtime.beginning_of_day..Time.current.localtime.end_of_day)
    .order("id :desc")
  end

  # GET /collection_entries/1 or /collection_entries/1.json
  def show
    @collection_entry = CollectionEntry.includes(egg_entries: :chicken).find(params.expect(:id))
  end

  # GET /collection_entries/new
  def new
    @collection_entry = CollectionEntry.new
    @collection_entry.egg_entries.build
    @users = User.all
    @chickens = Chicken.all
    # @egg_entry = EggEntry.new
  end

  # GET /collection_entries/1/edit
  def edit
    @users = User.all
    @chickens = Chicken.all
    # testing these assignments to see if I can allow user to see saved data in #edit
    @collection_entry = CollectionEntry.find(params[:id])
    @collection_entry.egg_entries = EggEntry.where(collection_entry_id: @collection_entry.id)
  end

  # POST /collection_entries or /collection_entries.json
  def create
    @collection_entry = CollectionEntry.new(collection_entry_params)

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
      @collection_entry = CollectionEntry.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def collection_entry_params
      # params.expect(collection_entry: [ :count, :user_id, :chicken_id ])
      # TODO - update expected params to match nested forms in collection_entry/_form
      # params.permit![:collection_entry]

      params.require(:collection_entry).permit(:user_id, egg_entries_attributes: [
        :id, :egg_count, :chicken_id, :collection_entry_id, :_destroy,
      ])
    end
end
