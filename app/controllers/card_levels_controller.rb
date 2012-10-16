class CardLevelsController < ApplicationController
  # GET /card_levels
  # GET /card_levels.json
  def index
    @card_levels = CardLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @card_levels }
    end
  end

  # GET /card_levels/1
  # GET /card_levels/1.json
  def show
    @card_level = CardLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card_level }
    end
  end

  # GET /card_levels/new
  # GET /card_levels/new.json
  def new
    @card_level = CardLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @card_level }
    end
  end

  # GET /card_levels/1/edit
  def edit
    @card_level = CardLevel.find(params[:id])
  end

  # POST /card_levels
  # POST /card_levels.json
  def create
    @card_level = CardLevel.new(params[:card_level])

    respond_to do |format|
      if @card_level.save
        format.html { redirect_to @card_level, notice: 'Card level was successfully created.' }
        format.json { render json: @card_level, status: :created, location: @card_level }
      else
        format.html { render action: "new" }
        format.json { render json: @card_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /card_levels/1
  # PUT /card_levels/1.json
  def update
    @card_level = CardLevel.find(params[:id])

    respond_to do |format|
      if @card_level.update_attributes(params[:card_level])
        format.html { redirect_to @card_level, notice: 'Card level was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @card_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /card_levels/1
  # DELETE /card_levels/1.json
  def destroy
    @card_level = CardLevel.find(params[:id])
    @card_level.destroy

    respond_to do |format|
      format.html { redirect_to card_levels_url }
      format.json { head :no_content }
    end
  end
end
