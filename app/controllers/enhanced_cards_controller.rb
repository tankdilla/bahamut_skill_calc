class EnhancedCardsController < ApplicationController
  before_filter :find_card_level
  
  # GET /enhanced_cards
  # GET /enhanced_cards.json
  def index
    @enhanced_cards = @card_level.enhanced_cards.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @enhanced_cards }
    end
  end

  # GET /enhanced_cards/1
  # GET /enhanced_cards/1.json
  def show
    @enhanced_card = @card_level.enhanced_cards.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @enhanced_card }
    end
  end

  # GET /enhanced_cards/new
  # GET /enhanced_cards/new.json
  def new
    @enhanced_card = @card_level.enhanced_cards.new
    
    setup_entry

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @enhanced_card }
    end
  end

  # GET /enhanced_cards/1/edit
  def edit
    @enhanced_card = @card_level.enhanced_cards.find(params[:id])
  end

  # POST /enhanced_cards
  # POST /enhanced_cards.json
  def create
    @enhanced_card = @card_level.enhanced_cards.new(params[:enhanced_card])

    respond_to do |format|
      if @enhanced_card.save
        format.html { redirect_to [@card_level, @enhanced_card], notice: 'Enhanced card was successfully created.' }
        format.json { render json: [@card_level, @enhanced_card], status: :created, location: @enhanced_card }
      else
        setup_entry
        format.html { render action: "new" }
        format.json { render json: @enhanced_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /enhanced_cards/1
  # PUT /enhanced_cards/1.json
  def update
    @enhanced_card = @card_level.enhanced_cards.find(params[:id])

    respond_to do |format|
      if @enhanced_card.update_attributes(params[:enhanced_card])
        format.html { redirect_to [@card_level, @enhanced_card], notice: 'Enhanced card was successfully updated.' }
        format.json { head :no_content }
      else
        setup_entry
        format.html { render action: "edit" }
        format.json { render json: @enhanced_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enhanced_cards/1
  # DELETE /enhanced_cards/1.json
  def destroy
    @enhanced_card = @card_level.enhanced_cards.find(params[:id])
    @enhanced_card.destroy

    respond_to do |format|
      format.html { redirect_to enhanced_cards_url }
      format.json { head :no_content }
    end
  end
  
  private
  def setup_entry
    @eligible_card_levels = @card_level.eligible_card_levels
  end
end
