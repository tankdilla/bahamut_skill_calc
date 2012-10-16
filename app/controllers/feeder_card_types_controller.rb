class FeederCardTypesController < ApplicationController
  before_filter :find_card_level, :find_enhanced_card
  
  # GET /feeder_card_types
  # GET /feeder_card_types.json
  def index
    @feeder_card_types = @enhanced_card.feeder_card_types.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeder_card_types }
    end
  end

  # GET /feeder_card_types/1
  # GET /feeder_card_types/1.json
  def show
    @feeder_card_type = @enhanced_card.feeder_card_types.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feeder_card_type }
    end
  end

  # GET /feeder_card_types/new
  # GET /feeder_card_types/new.json
  def new
    @feeder_card_type = @enhanced_card.feeder_card_types.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feeder_card_type }
    end
  end

  # GET /feeder_card_types/1/edit
  def edit
    @feeder_card_type = @enhanced_card.feeder_card_types.find(params[:id])
  end

  # POST /feeder_card_types
  # POST /feeder_card_types.json
  def create
    @feeder_card_type = @enhanced_card.feeder_card_types.new(params[:feeder_card_type])

    respond_to do |format|
      if @feeder_card_type.save
        format.html { redirect_to [@card_level, @enhanced_card, @feeder_card_type], notice: 'Feeder card type was successfully created.' }
        format.json { render json: @feeder_card_type, status: :created, location: @feeder_card_type }
      else
        format.html { render action: "new" }
        format.json { render json: @feeder_card_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feeder_card_types/1
  # PUT /feeder_card_types/1.json
  def update
    @feeder_card_type = @enhanced_card.feeder_card_types.find(params[:id])

    respond_to do |format|
      if @feeder_card_type.update_attributes(params[:feeder_card_type])
        format.html { redirect_to [@card_level, @enhanced_card, @feeder_card_type], notice: 'Feeder card type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feeder_card_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeder_card_types/1
  # DELETE /feeder_card_types/1.json
  def destroy
    @feeder_card_type = @enhanced_card.feeder_card_types.find(params[:id])
    @feeder_card_type.destroy

    respond_to do |format|
      format.html { redirect_to card_level_enhanced_card_feeder_card_types_url(@card_level, @enhanced_card) }
      format.json { head :no_content }
    end
  end
end
