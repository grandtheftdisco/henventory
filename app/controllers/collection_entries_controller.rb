class CollectionEntriesController < ApplicationController
  before_action :set_collection_entry, only: %i[ show edit update destroy ]

  # GET /collection_entries or /collection_entries.json
  def index
    @collection_entries = CollectionEntry.all
  end

  # GET /collection_entries/1 or /collection_entries/1.json
  def show
  end

  # GET /collection_entries/new
  def new
    @collection_entry = CollectionEntry.new
  end

  # GET /collection_entries/1/edit
  def edit
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
      params.expect(collection_entry: [ :count, :user_id, :chicken_id ])
    end
end
