class FeederCardType
  include Mongoid::Document
  field :name, type: String
  field :_id, type: String, default: ->{ name }
  
  embedded_in :enhanced_card
  embeds_many :feeder_cards
  
  before_create :set_defaults
  
  def set_defaults
    self._id = name.gsub(" ", "_").downcase
  end
  
  def eligible_card_levels
    current_feeder_card_levels = self.feeder_cards
    unless current_feeder_card_levels.empty?
      current_levels = current_feeder_card_levels.collect{|x| x.skill_level}
    else
      current_levels = []
    end
    
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] - current_levels
  end
end
