class FeederCardsController < ApplicationController
  before_filter :find_card_level, :find_enhanced_card, :find_feeder_card_type
  
  # GET /feeder_cards
  # GET /feeder_cards.json
  def index
    @feeder_cards = @feeder_card_type.feeder_cards.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeder_cards }
    end
  end

  # GET /feeder_cards/1
  # GET /feeder_cards/1.json
  def show
    @feeder_card = @feeder_card_type.feeder_cards.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feeder_card }
    end
  end

  # GET /feeder_cards/new
  # GET /feeder_cards/new.json
  def new
    @feeder_card = @feeder_card_type.feeder_cards.new
    
    setup_entry

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feeder_card }
    end
  end

  # GET /feeder_cards/1/edit
  def edit
    @feeder_card = @feeder_card_type.feeder_cards.find(params[:id])    
    @eligible_card_levels = 1.upto(10).collect{|x| x}
  end

  # POST /feeder_cards
  # POST /feeder_cards.json
  def create
    @feeder_card = @feeder_card_type.feeder_cards.new(params[:feeder_card])

    respond_to do |format|
      if @feeder_card.save
        format.html { redirect_to [@card_level, @enhanced_card, @feeder_card_type, @feeder_card], notice: 'Feeder card was successfully created.' }
        format.json { render json: @feeder_card, status: :created, location: @feeder_card }
      else
        setup_entry
        format.html { render action: "new" }
        format.json { render json: @feeder_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feeder_cards/1
  # PUT /feeder_cards/1.json
  def update
    @feeder_card = @feeder_card_type.feeder_cards.find(params[:id])

    respond_to do |format|
      if @feeder_card.update_attributes(params[:feeder_card])
        format.html { redirect_to [@card_level, @enhanced_card, @feeder_card_type, @feeder_card], notice: 'Feeder card was successfully updated.' }
        format.json { head :no_content }
      else
        setup_entry
        format.html { render action: "edit" }
        format.json { render json: @feeder_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeder_cards/1
  # DELETE /feeder_cards/1.json
  def destroy
    @feeder_card = @feeder_card_type.feeder_cards.find(params[:id])
    @feeder_card.destroy

    respond_to do |format|
      format.html { redirect_to card_level_enhanced_card_feeder_card_type_feeder_cards_url(@card_level, @enhanced_card, @feeder_card_type) }
      format.json { head :no_content }
    end
  end
  
  private
  def setup_entry
    @eligible_card_levels = @feeder_card_type.eligible_card_levels
  end
end
