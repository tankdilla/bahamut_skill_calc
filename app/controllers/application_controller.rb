class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def find_card_level
    @card_level = CardLevel.find(params[:card_level_id])
  end
  
  def find_enhanced_card
    unless @card_level.nil?
      @enhanced_card = @card_level.enhanced_cards.find(params[:enhanced_card_id])
    else
      @enhanced_card = nil
    end
  end
  
  def find_feeder_card_type
    unless @enhanced_card.nil?
      @feeder_card_type = @enhanced_card.feeder_card_types.find(params[:feeder_card_type_id])
    else
      @feeder_card_type = nil
    end
  end
end
